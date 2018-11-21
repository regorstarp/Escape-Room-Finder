//
//  RoomDetailViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 11/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseFirestore

class BusinessDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = UIActivityIndicatorView.Style.gray
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private lazy var activityIndicatorContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var business: Business!
    var rooms: [Room] = []
    var businessReference: DocumentReference?
    
    
    enum State {
        case loading
        case populated()
        case error(Error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        showActivityIndicator()
        loadBusiness()
    }
    
    private func loadBusiness() {
        guard let businessId = rooms.first?.businessId else {
            print("Loaded Business Detail with an empty room list")
            return
        }
        let ref = Firestore.firestore().collection("business").document(businessId)
        ref.getDocument { [unowned self] (document, error) in
            if let document = document, document.exists, let dict = document.data() , let business = Business(dictionary: dict) {
                self.business = business
                self.title = business.name
                self.tableView.isHidden = false
                self.hideActivityIndicator()
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func showActivityIndicator() {
        view.addSubview(activityIndicatorContentView)
        activityIndicatorContentView.addSubview(activityIndicator)
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            activityIndicatorContentView.topAnchor.constraint(equalTo: margins.topAnchor),
            activityIndicatorContentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            activityIndicatorContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContentView.centerYAnchor)
            ])
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicatorContentView.removeFromSuperview()
    }
}

extension BusinessDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Identifier")
        cell.textLabel?.text = rooms[indexPath.row].name
        cell.detailTextLabel?.text = "\(rooms[indexPath.row].duration)"
        return cell
    }
}
