//
//  Drawer.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 12/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol DrawerViewControllerDelegate {
    func dismiss()
}

// If I were to do this again, I would probably take the following approach:
//
// 1. Instead of using the `UIViewPropertyAnimator`s `fractionComplete` and `isReversed`,
//    I would update the position of the view at any point manually.
// 2. Only use a UIViewPropertyAnimator to "finish" the animation (with or without damping).
// 3. Remove the ability to "catch" the view mid-flight.
//    It has a little bit of jank, and with a fast animation doesn't seem that practical.
//    (Still should be interruptible and reversible, but with a pan gesture.)
// 4. Add rubberbanding to the top and bottom boundaries of the view.
// 5. Allow the view to have an arbitrary, potentially scrolling view as its content.

class DrawerViewController: UIViewController {
    
    private lazy var momentumView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.isTranslucent = true
        let titleItem = UINavigationItem(title: "Test")
        
        let doneButton = UIButton(type: .roundedRect)
        doneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = #colorLiteral(red: 0.8521460295, green: 0.8940392137, blue: 0.9998423457, alpha: 1)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        titleItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    
        navigationBar.setItems([titleItem], animated: false)
        return navigationBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        tableView.canCancelContentTouches = false
        return tableView
    }()
    
    var delegate: DrawerViewControllerDelegate?
    
    // todo: add an explicit tap recognizer as well
    private let panRecognier = UIPanGestureRecognizer()
    
    private var animator = UIViewPropertyAnimator()
    
    // todo: refactor state to use an enum with associated valued
    private var isOpen = false
    private var animationProgress: CGFloat = 0
    
    private var closedTransform = CGAffineTransform.identity
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(momentumView)
        NSLayoutConstraint.activate([
            momentumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            momentumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            momentumView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            momentumView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 400)
            ])
        
        momentumView.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: momentumView.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: momentumView.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: momentumView.trailingAnchor)
            ])
        
        momentumView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: momentumView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: momentumView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: momentumView.bottomAnchor)
            ])
        
//        closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height * 0.4)
//        momentumView.transform = closedTransform
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: momentumView.bounds, cornerRadius: 15).cgPath
        momentumView.layer.mask = maskLayer
    }
    
    @objc func done() {
        delegate?.dismiss()
    }
}
