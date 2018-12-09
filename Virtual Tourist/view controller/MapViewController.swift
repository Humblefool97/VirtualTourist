//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Rajeev Kalkunte RANGANATHAN on 20/11/18.
//  Copyright © 2018 Rajeev Kalkunte RANGANATHAN. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreData

class MapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteButton: UIButton!
    var pinAnnotation: MKPointAnnotation? = nil
    var pinList:[Pin] = []
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isHidden = true
        navigationItem.rightBarButtonItem = editButtonItem
        mapView.delegate = self
        setupFetchControllerRequest()
        loadPins()
    }
    
    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
        if sender.state == .began {
            pinAnnotation = MKPointAnnotation()
            pinAnnotation!.coordinate = coordinates
            mapView.addAnnotation(pinAnnotation!)
        }else if sender.state == .changed{
            pinAnnotation!.coordinate = coordinates
        } else if sender.state == .ended {
            saveCoordinatesToDB(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
    }
    
    private func setupFetchControllerRequest(){
        let fetchRequest = Pin.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Pin>
        do {
            try fetchedResultsController.performFetch()
            let count = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<count{
                let pin = fetchedResultsController.object(at: IndexPath(row: index, section: 0))
                pinList.append(pin)
            }
        } catch  {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    private func loadPins(){
        if !pinList.isEmpty{
            for pin in pinList{
                let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                addAnnotationToMap(fromCoord: coordinate)
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deleteButton.isHidden = !editing
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushSegue"{
            let coordinates = sender as? CLLocationCoordinate2D
            let destinationVc = segue.destination as! PhotoViewController
            for pin in pinList{
                if pin.latitude == coordinates?.latitude && pin.longitude == coordinates?.longitude{
                    destinationVc.pin = pin
                    break
                }
            }
        }
    }
    //MARK: - Editing
    private func saveCoordinatesToDB(latitude:Double,longitude:Double){
        let pin = Pin(latitude: latitude, longitude: longitude, context: DataController.shared.viewContext)
        DataController.shared.saveContext()
        pinList.append(pin)
    }
    
    private func addAnnotationToMap(fromCoord: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = fromCoord
        mapView.addAnnotation(annotation)
    }
    
    private func removePinFromDb(pin:Pin){
        DataController.shared.viewContext.delete(pin)
        DataController.shared.saveContext()
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        if isEditing{
            let coordinates = annotation.coordinate
            let latitude = coordinates.latitude
            let longitude = coordinates.longitude
            for pin in pinList{
                if(pin.latitude == latitude && pin.longitude == longitude){
                    removePinFromDb(pin:pin)
                }
            }
            mapView.removeAnnotation(annotation)
            return
        }else{
            performSegue(withIdentifier: "pushSegue", sender: view.annotation?.coordinate)
           // mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }
}

