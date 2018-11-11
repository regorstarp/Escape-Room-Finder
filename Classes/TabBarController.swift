//
//  TabBarController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 10/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), tag: 0)
        let nc = UINavigationController(rootViewController: mapViewController)
        nc.navigationBar.isHidden = true
        viewControllers = [nc]
    }
}
