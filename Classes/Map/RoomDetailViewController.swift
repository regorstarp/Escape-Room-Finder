//
//  RoomDetailViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 11/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit


class RoomDetailViewController: UIViewController {
    @IBOutlet weak var gripperView: UIView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    enum State {
        case loading
        case populated()
        case error(Error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Room detail"
        closeButton.action = #selector(dismissViewController)
        view.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.968627451, blue: 0.9450980392, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       gripperView.layer.cornerRadius = 2
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        let yComponent = UIScreen.main.bounds.height - 200
        view.frame = CGRect(x: 0, y: yComponent, width: view.frame.width, height: 260)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: 260)
        }
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}

extension RoomDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//        if scrollView.contentOffset.y <= 1 {
//
//        }
//    }
    
    
}
