//
//  AppDelegate.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 07/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
//        UINavigationBar.appearance().barTintColor = UIColor.darkColor
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
//        
//        UITabBar.appearance().barTintColor = UIColor.darkColor
        return true
    }
}

