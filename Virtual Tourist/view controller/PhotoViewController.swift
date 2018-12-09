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
class PhotoViewController: UIViewController,MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    //MARK: - Properties
    var pin:Pin!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var emptyScreenLabel: UILabel!
    @IBOutlet weak var primaryActionButton: UIButton!
    var photos:[String] = []
    @IBOutlet weak var collectionView: UICollectionView!
    let spacingBetweenItems:CGFloat = 5
    let totalCellCount:Int = 25
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        primaryActionButton.isHidden = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        loadPin()
        loadImages()
        collectionView.delegate = self
    }
    
    private func loadImages(){
        NetworkUtility.getFlickerPhotos(latitude: pin.latitude, longitude: pin.longitude){(success,urlList,errorMessage) in
            if success {
                if let urlList = urlList{
                    if !urlList.isEmpty{
                        for url in urlList{
                            //Save & display
                            print(url)
                            self.photos.append(url)
                        }
                        performUIUpdatesOnMain {
                            if(self.photos.count > 0){
                                self.collectionView.reloadData()
                                self.emptyScreenLabel.isHidden = true
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
                //TODO:Display error message
                print(errorMessage)
            }
        }
    }
    private func loadPin(){
        let coord = CLLocationCoordinate2D(latitude: (pin?.latitude)!, longitude: (pin?.longitude)!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapView.addAnnotation(annotation)
        let distance = CLLocationDistance(5000.0)
        let region = MKCoordinateRegionMakeWithDistance(coord, distance, distance)
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {}
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {}
    
    //MARKL - Collectionview delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! PhotoViewCell
        collectionViewCell.progressIndicator.startAnimating()
        let urlInString = photos[indexPath.row]
        if let url = URL(string: urlInString){
            if let imageData = NSData(contentsOf: url){
                let image = UIImage(data: imageData as Data)
                collectionViewCell.image.image = image
                collectionViewCell.progressIndicator.stopAnimating()
            }
        }
        return collectionViewCell
    }
    
}
