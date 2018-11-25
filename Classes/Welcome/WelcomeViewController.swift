//
//  WelcomeViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 10/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        FirebaseApp.configure()
        
//        let ref = Database.database().reference(withPath: "escape-room")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//
//            if !snapshot.exists() { return }
//            let snapshotValue = snapshot.children.allObjects as! [DataSnapshot]
//            snapshotValue.forEach({
//                let snap = $0.value as! [String:Any]
//
//            })
//
//        })
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: signInButton.bounds, cornerRadius: 8).cgPath
        signInButton.layer.mask = maskLayer
    }
    
    @IBAction func onRegisterButton() {
        let alert = UIAlertController(
            title: NSLocalizedString("Register", comment: ""),
            message: NSLocalizedString("Register with a Personal Email and password.", comment: ""),
            preferredStyle: .alert
        )
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Email", comment: "")
        }
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Password", comment: "")
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Register", style: .default, handler: { (action) in
            guard let email = alert.textFields?[0].text, let password = alert.textFields?[1].text else { return }
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                if let user = authResult?.user {
                    
                } else {
                    self.showAlert(title: "Register Error", message: error?.localizedDescription ?? "")
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSignInButton() {
        let alert = UIAlertController(
            title: NSLocalizedString("Sign In", comment: ""),
            message: NSLocalizedString("Sign in with a Personal Email and password.", comment: ""),
            preferredStyle: .alert
        )
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Email", comment: "")
            textField.textContentType = UITextContentType.emailAddress
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .continue
        }
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Password", comment: "")
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Forgot Password?", style: .destructive, handler: { (action) in
            
            let alert = UIAlertController(
                title: NSLocalizedString("Reset Password", comment: ""),
                message: NSLocalizedString("Enter your Email to recieve a reset link.", comment: ""),
                preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = NSLocalizedString("Email", comment: "")
                textField.textContentType = UITextContentType.emailAddress
                textField.keyboardType = .emailAddress
            }
            alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (action) in
                guard let email = alert.textFields?[0].text else { return }
                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                    if let err = error {
                        self.showAlert(title: "Reset Password Error", message: err.localizedDescription)
                    } else {
                        self.showAlert(title: "Email Sent", message: "Check your Email to reset your password.")
                    }
                }}))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: { (action) in
            guard let email = alert.textFields?[0].text, let password = alert.textFields?[1].text else { return }
            Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
                if let err = error {
                    self.showAlert(title: "Sign In Error", message: err.localizedDescription)
                } else {
                    self.present(MapViewController(), animated: true)
                }
            })
        }))
        
        present(alert, animated: true)
    }

}
