//
//  PhotoViewController+Delegate.swift
//  Virtual Tourist
//
//  Created by Rajeev Ranganathan on 10/12/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension PhotoViewController:NSFetchedResultsControllerDelegate,MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.collectionView.insertItems(at:[newIndexPath!])
            itemCount += 1
        case .delete:
            self.collectionView.deleteItems(at: [indexPath!])
            itemCount -= 1
        case .update:
            self.collectionView.reloadItems(at: [indexPath!])
            itemCount += 1
        default:
            print("Operation not supported")
        }
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
    
    //MARK - Collectionview delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionInfo = self.fetchedResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deletedIndexPath = indexPath
        isInDeleteMode = true
        primaryActionButton.setTitle("REMOVE SELECTED", for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! PhotoViewCell
        collectionViewCell.imageView.image  = nil
        collectionViewCell.progressIndicator.startAnimating()
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoObj = fetchedResultsController.object(at: indexPath)
        let photoViewCell = cell as! PhotoViewCell
        downloadImage(photoObject:photoObj){ downloadedImage in
            photoViewCell.imageView.image = downloadedImage
            photoViewCell.progressIndicator.stopAnimating()
            self.primaryActionButton.isHidden = false
        }
    }
}
