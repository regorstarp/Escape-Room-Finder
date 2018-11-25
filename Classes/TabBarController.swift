//
//  TabBarController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 20/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseUI

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let mapViewController = EscapeRoomDetailViewController()
        let mapTabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "room"), tag: 0)
        
        mapViewController.tabBarItem = mapTabBarItem
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        
        let historyViewController = CompletedViewController()
        let historyTabBarItem = UITabBarItem(title: "Completed", image: UIImage(named: "completed"), tag: 1)
        historyViewController.tabBarItem = historyTabBarItem
        let historyNavigationController = UINavigationController(rootViewController: historyViewController)
        
        let favoritesViewController = SavedViewController()
        let favoritesTabBarItem = UITabBarItem(title: "Saved", image: UIImage(named: "bookmark"), tag: 2)
        favoritesViewController.tabBarItem = favoritesTabBarItem
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        let accountViewController = AccountViewController()
        let accountTabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 3)
        accountViewController.tabBarItem = accountTabBarItem
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        
        viewControllers = [mapNavigationController, historyNavigationController, favoritesNavigationController, accountNavigationController]
    }
}
