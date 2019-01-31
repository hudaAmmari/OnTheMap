//
//  MapViewController.swift
//  onTheMap
//
//  Created by Huda  on 25/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    
    override func viewDidLoad ()
    {
        super.viewDidLoad ()
         loadUserInfo()
         loadStudentsInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapView.delegate = self
     }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 1
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 1
            self.showStudentsInformation(SharedStudentsInformation.shared.studentsInformation)
        }
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
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    
 
    private func showStudentsInformation(_ studentsInformation: [StudentInformation]) {
        mapView.removeAnnotations(mapView.annotations)
        for info in studentsInformation where info.latitude != 0 && info.longitude != 0 {
            let annotation = MKPointAnnotation()
            annotation.title = info.fullName
            annotation.subtitle = info.mediaURL
            annotation.coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private func loadUserInfo() {
        _ = Client.shared().getStudentUser(completionHandler: { (studentInfo, error) in
            if let error = error {
                self.showAlart(Title: "Error", Message: error.localizedDescription)
                return
            }
            Client.shared().userName = studentInfo?.user?.name ?? ""
        })
    }
    
    @IBAction func addOrUpdateLocation(_ sender: Any) {
        enableControllers(false)
        Client.shared().getStudentInformationLocation { (studentInformation, error) in
            if let error = error {
                self.showAlart(Title: "Error fetching student location", Message: error.localizedDescription)
            } else if let studentInformation = studentInformation {
                let msg = "User \"\(studentInformation.fullName)\" has already posted a Student Location. Whould you like to Overwrite it?"
                self.showConfirmationAlert(withMessage: msg, actionTitle: "Overwrite", action: {
                    self.showPostingView(studentLocationID: studentInformation.locationID)
                })
            }
            else {
                self.performUIUpdatesOnMain {
                    self.showPostingView()
                }
            }
            self.enableControllers(true)
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        loadStudentsInformation()
    }
    
    @objc private func loadStudentsInformation() {
        NotificationCenter.default.post(name: .reloadStarted, object: nil)
        Client.shared().getStudentsInformation { (studentsInformation, error) in
            if let error = error {
                self.showAlart(Title: "Error", Message: error.localizedDescription)
                NotificationCenter.default.post(name: .reloadCompleted, object: nil)
                return
            }
            if let studentsInformation = studentsInformation {
                SharedStudentsInformation.shared.studentsInformation = studentsInformation
            }
            NotificationCenter.default.post(name: .reloadCompleted, object: nil)
        }
    }
    
    private func showPostingView(studentLocationID: String? = nil) {
        let postingView = storyboard?.instantiateViewController(withIdentifier: "InformationPostViewController") as! InformationPostViewController
        postingView.locationID = studentLocationID
        navigationController?.pushViewController(postingView, animated: true)
    }
    
    private func enableControllers(_ enable: Bool) {
        performUIUpdatesOnMain {
            self.addButton.isEnabled = enable
            self.reloadButton.isEnabled = enable
            self.logoutButton.isEnabled = enable
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        Client.shared().logout { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlart(Title: "Error", Message: error!.localizedDescription) }
        }
    }
}


