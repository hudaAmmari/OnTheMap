//
//  LoginViewController.swift
//  onTheMap
//
//  Created by Huda  on 22/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate{

    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
   
    
    
    @IBAction func loginFunction(_ sender: Any) {
        enableControllers(false)
        
        let email = emailTextField.text!
        let password = passwordTextField.text!

        //check if email text field is not empty
        guard !email.isEmpty else {
            enableControllers(true)
            showAlart(Title: "Field required", Message: "Please fill in your email.")
            return
        }
        
        //check if password text field is empty
        guard !password.isEmpty else {
            enableControllers(true)
            showAlart(Title: "Field required", Message: "Please fill in your password.")
            return
        }

         authenticateUser(email: email, password: password)
    }
    
    
    private func authenticateUser(email: String, password: String) {
        Client.shared().authenticateUser(Email: email, Password: password) { (success, errorMessage) in
            if success {
                self.performUIUpdatesOnMain {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }
                 self.performSegue(withIdentifier: "showMap", sender: nil)
             }
            else {
                self.performUIUpdatesOnMain {
                    self.showAlart(Title: "Login falied", Message: errorMessage ?? "Error while performing login.")
                }
            }
            self.enableControllers(true)
        }
    }
        
    
    @IBAction func signupFunction(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signin") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    
    }
    
    //Mark:-
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
        if passwordTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Hide the keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    //get height of keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func enableControllers(_ enable: Bool) {
        self.enableUI(views: emailTextField, passwordTextField, loginButton, signupButton, enable: enable)
    }
    
}

