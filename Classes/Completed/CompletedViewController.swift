//
//  CompletedViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 21/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseFirestore

class CompletedViewController: UIViewController {

    private let authUI = FUIAuth.defaultAuthUI()!
    
    private lazy var tableView = UITableView(frame: view.frame, style: .grouped)
    private var userId: String? = Auth.auth().currentUser?.uid
    
    private let userNotLoggedViewController: UIViewController = UserNotLoggedViewController(imageName: "completed-logo")
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = UIActivityIndicatorView.Style.gray
        return activityIndicatorView
    }()
    
    private var rooms: [Room] = []
    private var completedRooms: [CompletedRoom] = []
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    private var listener: ListenerRegistration?
    private let dispatchGroup = DispatchGroup()
    
    
    fileprivate func observeQuery() {
        guard userId != nil, let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error feching snapshot results: \(error!)")
                return
            }
        
            let models = snapshot.documents.map { (document) -> CompletedRoom in
                if let model = CompletedRoom(dictionary: document.data()) {
                    return model
                }
                else {
                    fatalError("Unable to initialize type \(CompletedRoom.self) with dictionary \(document.data()) ")
                }
            }
            self.completedRooms = models
            self.fetchRooms()
        }
    }
    
    fileprivate func fetchRooms() {
        rooms = []
        for index in 0..<completedRooms.count {
            dispatchGroup.enter()
            let roomId = completedRooms[index].roomId
            let ref = Firestore.firestore().collection("room").document(roomId)
            ref.getDocument { (document, error) in
                if let document = document, let data = document.data(), let room = Room(dictionary: data, documentId: document.documentID) {
                    self.rooms.append(room)
                    self.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.tableView.reloadData()
            self.hideActivityIndicator()
        })
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userId = Auth.auth().currentUser?.uid
        if userId == nil && !children.contains(userNotLoggedViewController){
            add(userNotLoggedViewController)
        } else {
            observeQuery()
        }
    }
    
    deinit {
        listener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Completed"
        
        view.addSubview(tableView)
        configureTableView()
        
        guard let userId = userId else { return }
        showActivityIndicator()
        query = Firestore.firestore().collection("completed").whereField("userId", isEqualTo: userId)
    }
    
    private func showActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.removeFromSuperview()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompletedCell")
    }
}


extension CompletedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].name
        return cell
    }
    
    
}
