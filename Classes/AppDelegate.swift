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
        
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.05882352941, green: 0.09019607843, blue: 0.1098039216, alpha: 1)
        UINavigationBar.appearance().shadowImage = #imageLiteral(resourceName: "barShadow")
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UITextField.appearance().keyboardAppearance = .dark
        
        
//        UINavigationBar.appearance().barTintColor = UIColor.darkColor
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
//        
//        UITabBar.appearance().barTintColor = UIColor.darkColor
        return true
    }
}

