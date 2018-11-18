//
//  RoomDetailViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 11/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit


class BusinessDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var business: Business!
    var rooms: [Room] = []
    
    enum State {
        case loading
        case populated()
        case error(Error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = business.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
    }
}

extension BusinessDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].name
        return cell
    }
}
