
//  TableViewController.swift
//  onTheMap
//
//  Created by Huda  on 25/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentsInformation()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return SharedStudentsInformation.shared.studentsInformation.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableCell" , for: indexPath) as! StudentTableCell
        let student = SharedStudentsInformation.shared.studentsInformation[indexPath.row]
         cell.nameLabel!.text = "\(student.fullName)"
         cell.detailLabel!.text = "\(student.mediaURL)"
         return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = SharedStudentsInformation.shared.studentsInformation[indexPath.row]
        let toOpen = student.mediaURL
        guard let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) else {
            showAlart(Message: "Invalid link.")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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



