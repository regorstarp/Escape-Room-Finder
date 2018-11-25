//
//  CompletedViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 21/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class SavedViewController: BaseViewController {

    private let authUI = FUIAuth.defaultAuthUI()!
    private var isUserLoggedIn : Bool {
        get {
            return Auth.auth().currentUser == nil ? false : true
        }
    }
    private let userNotLoggedViewController = UserNotLoggedViewController(imageName: "bookmark-logo")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isUserLoggedIn && !children.contains(userNotLoggedViewController){
            add(userNotLoggedViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved"
        view.backgroundColor = .white
        
        if !isUserLoggedIn && !children.contains(userNotLoggedViewController){
            add(userNotLoggedViewController)
        }
    }
}
