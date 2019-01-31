//
//  Extensions.swift
//  onTheMap
//
//  Created by Huda  on 26/03/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//
import UIKit
import Foundation

extension UIViewController {
    

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showAlart(Title: String = "Alart", Message: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let alart = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
            alart.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alart, animated: true, completion: nil)
        }
    }

    func showConfirmationAlert(withMessage: String, actionTitle: String, action: @escaping () -> Void) {
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: nil, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (alertAction) in
                action()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
            }
        }

    func enableUI(views: UIControl..., enable: Bool) {
        performUIUpdatesOnMain {
            for view in views {
                view.isEnabled = enable
            }
        }
    }

}


extension Notification.Name {
    static let reload = Notification.Name("reload")
    static let reloadStarted = Notification.Name("reloadStarted")
    static let reloadCompleted = Notification.Name("reloadCompleted")
}

