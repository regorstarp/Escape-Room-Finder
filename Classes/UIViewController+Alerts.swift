//
//  UIViewController+Alerts.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 07/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseUI

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.configured(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showSignInAlert(forAction action: String) {
        let alert = UIAlertController(title: "Sign In to \(action)", message: "You need to be signed in to \(action)", preferredStyle: .alert)
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { (action) in
            self.present(FUIAuth.defaultAuthUI()!.authViewController(), animated: true)
        }
        alert.addAction(signInAction)
        let createAccountAction = UIAlertAction(title: "Create Account", style: .default) { (action) in
            self.present(FUIAuth.defaultAuthUI()!.authViewController(), animated: true)
        }
        alert.addAction(createAccountAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension UIAlertController {
    
    static func configured(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        return alertController
    }
}

extension UIViewController {
    
    //MARK: ChildViewControllers
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
