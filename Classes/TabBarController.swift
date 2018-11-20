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
        let mapViewController = MapViewController()
        let mapTabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        
        mapViewController.tabBarItem = mapTabBarItem
        mapViewController.tabBarItem.title = "Explore"
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        
        let favoritesViewController = UIViewController()
        let favoritesTabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        favoritesTabBarItem.title = "Favorites"
        favoritesViewController.tabBarItem = favoritesTabBarItem
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        let historyViewController = UIViewController()
        let historyTabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        historyTabBarItem.title = "Account"
        historyViewController.tabBarItem = historyTabBarItem
        let historyNavigationController = UINavigationController(rootViewController: historyViewController)
        
        
        let accountViewController = AccountViewController()
        let accountTabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        accountTabBarItem.title = "Account"
        accountViewController.tabBarItem = accountTabBarItem
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        
        viewControllers = [mapNavigationController, historyNavigationController, favoritesNavigationController, accountNavigationController]
    }
}
