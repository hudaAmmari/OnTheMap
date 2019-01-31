//
//  InformationPostViewController.swift
//  onTheMap
//
//  Created by Huda  on 25/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var iconWorld: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    var locationID: String?
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear (animated)
        locationTextField.delegate = self
        websiteTextField.delegate = self
        
        setUpNavBar()
        self.tabBarController?.tabBar.isHidden = true
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear (animated)
        self.tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func findLocation(_ sender: Any) {
        let location = locationTextField.text!
        let link = websiteTextField.text!
        
        guard location.isEmpty == false &&  link.isEmpty == false else {
            showAlart(Message: "All fields are required.")
            return
        }
    
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            showAlart(Message: "Please provide a valid link.")
            return
        }
        geocode(location: location)
    }
        
    private func geocode(location: String) {
        enableControllers(false)
        geocoder.geocodeAddressString(location) { (placemarkers, error) in
        
            self.enableControllers(true)
            if let error = error {
                self.showAlart(Title: "Error", Message: "Unable to Forward Geocode Address (\(error))")
            }
            else {
                var location: CLLocation?
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    self.submitStudentLocation(location.coordinate)
                }
                else {
                    self.showAlart(Message: "No Matching Location Found")
                }
            }
        }
    }
    
    private func submitStudentLocation(_ coordinate: CLLocationCoordinate2D) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "PinLocationViewController") as! PinLocationViewController
        viewController.studentInformation = buildStudentInfo(coordinate)
        navigationController?.pushViewController(viewController, animated: true)
  
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        let nameComponents = Client.shared().userName.components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.last ?? ""
        
        var studentInfo = [
            "uniqueKey": Client.shared().userKey,
            "firstName": firstName,
            "lastName": lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let locationID = locationID {
            studentInfo["objectId"] = locationID as AnyObject
        }
        return StudentInformation(studentInfo)
    }
        
    // Mark :-
    private func enableControllers(_ enable: Bool) {
        self.enableUI(views: locationTextField, websiteTextField, findLocationButton, enable: enable)
    }
        
    private func setUpNavBar(){
        //For title in navigation bar
        self.navigationItem.title = "Add Location"
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Cancel"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    //Show the keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        if websiteTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    //Hide the keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        if websiteTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }

    //get height of keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

}
