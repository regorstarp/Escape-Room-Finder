//
//  EscapeRoomDetailViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 25/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class EscapeRoomDetailViewController: UIViewController {
    
    private lazy var tableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: ImageViewCell.identifier)
        tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.identifier)
    }
    
    private func setupNavigationBar() {
        let bookmarkItem = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(addBookmark(sender:)))
        
        let completedItem = UIBarButtonItem(image: UIImage(named: "complete-button"), style: .plain, target: self, action: #selector(addCompleted(sender:)))
        
        let ratedItem = UIBarButtonItem(image: UIImage(named: "emptyStar"), style: .plain, target: self, action: #selector(addRated(sender:)))
        
        
        
        navigationItem.rightBarButtonItems = [ratedItem ,completedItem, bookmarkItem]
    }
    
    @objc func addRated(sender: UIBarButtonItem) {
        sender.action = #selector(removeRated(sender:))
        sender.image = UIImage(named: "filledStar")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func removeRated(sender: UIBarButtonItem) {
        sender.action = #selector(addRated(sender:))
        sender.image = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func addCompleted(sender: UIBarButtonItem) {
        sender.action = #selector(removeCompleted(sender:))
        sender.image = UIImage(named: "complete-button-selected")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func removeCompleted(sender: UIBarButtonItem) {
        sender.action = #selector(addCompleted(sender:))
        sender.image = UIImage(named: "complete-button")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func addBookmark(sender: UIBarButtonItem) {
        sender.action = #selector(removeBookmark(sender:))
        sender.image = UIImage(named: "bookmark-filled")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func removeBookmark(sender: UIBarButtonItem) {
        sender.action = #selector(addBookmark(sender:))
        sender.image = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
    }
}

extension EscapeRoomDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageViewCell.identifier, for: indexPath) as? ImageViewCell else { return UITableViewCell() }
            cell.configure(imageName: "test")
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell else { return UITableViewCell() }
            return cell
        }
    }
    
}

extension EscapeRoomDetailViewController: ThumbnailDelegate {
    func onTap(image: UIImage?) {
        let imageViewController = ImageViewController()
        imageViewController.image = image
        present(UINavigationController(rootViewController: imageViewController), animated: true)
    }
}
