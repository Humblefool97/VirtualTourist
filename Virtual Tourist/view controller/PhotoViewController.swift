//
//  PhotoViewController.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 02/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import CoreData

class PhotoViewController: UIViewController {
    //MARK: - Properties
    var pin:Pin!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var emptyScreenLabel: UILabel!
    @IBOutlet weak var primaryActionButton: UIButton!
    var photos:[String] = []
    @IBOutlet weak var collectionView: UICollectionView!
    let spacingBetweenItems:CGFloat = 5
    let totalCellCount:Int = 25
    private let minItemSpacing: CGFloat = 8
    private let itemWidth: CGFloat      = 100
    private let headerHeight: CGFloat   = 32
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    var totalNumOfPages = 0
    var itemCount = 0
    var deletedIndexPath:IndexPath? = nil
    var isInDeleteMode:Bool = false
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    //MARK: - Methods
    fileprivate func setupFetchResultsController(){
        let fetchRequest = NSFetchRequest<Photo>(entityName:"Photo")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin == %@", argumentArray: [pin])
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchResultsController()
        mapView.delegate = self
        primaryActionButton.isHidden = true
        updateFlowLayout(view.frame.size)
        // configureCollectionView()
        collectionView.delegate = self
        loadPin()
        if let photos = pin.photo, photos.count == 0 {
            loadImages()
        }
    }
    
    private func loadImages(){
        NetworkUtility.getFlickerPhotos(latitude: pin.latitude, longitude: pin.longitude,pageNum:totalNumOfPages){(success,photos,errorMessage) in
            if success {
                if let photosObj = photos , let urlList = photosObj.urlList{
                    if !urlList.isEmpty{
                        for url in urlList{
                            //Save & display
                            print(url)
                            self.photos.append(url)
                        }
                        performUIUpdatesOnMain {
                            if(self.photos.count > 0){
                                self.storePhotos()
                                self.emptyScreenLabel.isHidden = true
                                self.totalNumOfPages = photosObj.numOfPages
                            }
                        }
                    }else{
                        performUIUpdatesOnMain {
                            self.emptyScreenLabel.isHidden = false
                            self.primaryActionButton.isHidden = true
                        }
                    }
                }
            }else{
                print(errorMessage!)
            }
        }
    }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        let landscape = withSize.width > withSize.height
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        let dimension = (withSize.width - ((items + 1) * space)) / items
        collectionFlowLayout?.minimumInteritemSpacing = space
        collectionFlowLayout?.minimumLineSpacing = space
        collectionFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        collectionFlowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    private func storePhotos(){
        for url in photos {
            _ = Photo(imageUrl: url, forPin: pin, context: DataController.shared.viewContext)
            DataController.shared.saveContext()
        }
    }
    
   public func onCellSelectedForDeleted(at index:IndexPath){
        deletedIndexPath = index
        primaryActionButton.setTitle("Remove selected", for:.normal)
        isInDeleteMode = true
    }
    
    @IBAction func onFetchNewImage(_ sender: UIButton) {
        if(!isInDeleteMode){
            loadImages()
            collectionView.reloadData()
        }else{
            if let indexPath = deletedIndexPath {
                let photoToDelete = fetchedResultsController.object(at: indexPath)
                DataController.shared.viewContext.delete(photoToDelete)
                DataController.shared.saveContext()
                deletedIndexPath = nil
                isInDeleteMode = false
                primaryActionButton.setTitle("New Collection", for:.normal)
            }
        }
    }
    private func loadPin(){
        let coord = CLLocationCoordinate2D(latitude: (pin?.latitude)!, longitude: (pin?.longitude)!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapView.addAnnotation(annotation)
        let distance = CLLocationDistance(30000.00)
        let region = MKCoordinateRegionMakeWithDistance(coord, distance, distance)
        self.mapView.setRegion(region, animated: true)
    }
    
    //Get the photo object.
    //Check if the photo already has image,if yes,display
    //else,add to DB
    func downloadImage(photoObject:Photo,completionHandler handler: @escaping (_ image: UIImage) -> Void){
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            if let imageData = photoObject.image{
                if let image = UIImage(data: Data(referencing: imageData as NSData)){
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.emptyScreenLabel.isHidden = true
                        handler(image)
                    })
                }
            }else{
                if let photoUrl = photoObject.url{
                    if let url = URL(string: photoUrl), let imgData = try? Data(contentsOf: url), let img = UIImage(data: imgData) {
                        photoObject.image = imgData
                        // all set and done, run the completion closure!
                        DispatchQueue.main.async(execute: { () -> Void in
                            DataController.shared.saveContext()
                            handler(img)
                        })
                    }
                }
            }
        }
    }
}
