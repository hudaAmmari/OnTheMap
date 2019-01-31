//
//  PinLocationViewController.swift
//  onTheMap
//
//  Created by Huda  on 26/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PinLocationViewController: UIViewController, MKMapViewDelegate {
  
   var studentInformation: StudentInformation?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        activityIndicator.isHidden = true
        
        if let studentLocation = studentInformation {
            let location = StudentInformationJSON (
                createdAt: "",
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                objectId: "",
                uniqueKey: nil,
                updatedAt: ""
            )
            showLocations(location: location)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear (animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear (animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let toOpen = view.annotation?.subtitle!
            guard let url = URL(string: toOpen!), UIApplication.shared.canOpenURL(url) else {
                showAlart(Message: "Invalid link.")
                return
            }
            UIApplication.shared.open(url, options: [:])
            
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if let studentLocation = studentInformation {
            enableControllers(true)
            self.activityIndicator.isHidden = false
            if studentLocation.locationID == nil {
                // POST
               Client.shared().postStudentLocation(info: studentLocation, completionHandler: { (success, error) in
                    self.enableControllers(false)
                    self.activityIndicator.isHidden = true
                    self.handleSyncLocationResponse(error: error)
                })
            } else {
                // PUT
                
                Client.shared().updateStudentLocation(info: studentLocation, completionHandler: { (success, error) in
                    self.enableControllers(false)
                    self.activityIndicator.isHidden = true
                    self.handleSyncLocationResponse(error: error)
                })
            }
        }
    }
    
    
    private func showLocations(location: StudentInformationJSON) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: StudentInformationJSON) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    private func handleSyncLocationResponse(error: NSError?) {
        if let error = error {
            showAlart(Title: "Error", Message: error.localizedDescription)
        } else {
            showAlart(Title: "Success", Message: "Student Location updated!", action: {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                self.navigationController?.pushViewController(viewController, animated: true)
                
                NotificationCenter.default.post(name: .reload, object: nil)
            })
        }
    }
    
    private func enableControllers(_ enable: Bool) {
        performUIUpdatesOnMain {
            self.submitButton.isEnabled = !enable
            self.mapView.alpha = enable ? 0.5 : 1
            enable ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
}

