//
//  ListTableViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 14/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var rooms: [Room] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let identifier = "RoomCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestCell.identifier, for: indexPath)
//        cell.textLabel?.text = rooms[indexPath.row].name
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = EscapeRoomDetailViewController()
        let room = rooms[indexPath.row]
        detailVC.documentIds = DocumentIds(business: room.businessId, room: room.documentId)
        parent?.navigationController?.pushViewController(detailVC, animated: true)
    }

}

class TestCell: UITableViewCell {
    static let identifier = "TestCell"
    
    private var roomImageView = UIImageView()
    private var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        roomImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        roomImageView.layer.cornerRadius = 10
        roomImageView.layer.masksToBounds = true
        roomImageView.image = #imageLiteral(resourceName: "bajozero")
        titleLabel.text = "Bajo Zero"
        titleLabel.textAlignment = .center
        
        addSubview(roomImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            roomImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            roomImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            roomImageView.widthAnchor.constraint(equalToConstant: 150),
            roomImageView.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.topAnchor.constraint(equalTo: roomImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
