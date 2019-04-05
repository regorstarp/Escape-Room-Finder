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
    
    private lazy var tableView = UITableView(frame: view.frame, style: .grouped)
    private lazy var loadingView = LoadingView(frame: view.frame)
    private let userNotLoggedViewController: UIViewController = UserNotLoggedViewController(imageName: "completed-logo")
    private var userID: String? = Auth.auth().currentUser?.uid
    
    private var rooms: [Room] = []
    private var completedRooms: [CompletedRoom] = []
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
//                observeQuery()
            }
        }
    }
    private var listener: ListenerRegistration?
    private let dispatchGroup = DispatchGroup()
    private var firstTime = true
    
    fileprivate func observeQuery() {
        firstTime = true
        guard let query = query else { return }
        stopObserving()
        // Display data from Firestore, part one
        
        listener = query.addSnapshotListener { (snapshot, error) in
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
    
    fileprivate func fetch(room id: String) {
        
    }
    
    fileprivate func fetchRooms() {
        guard firstTime == true else { return }
        firstTime = false
        rooms = []
        for index in 0..<completedRooms.count {
            dispatchGroup.enter()
            let roomId = completedRooms[index].roomId

            let ref = Firestore.firestore().collection("room").document(roomId)
            ref.getDocument { (document, error) in
                if let document = document, let data = document.data(), var room = Room(dictionary: data, documentId: document.documentID) {
                    //to keep the list ordered by most recent
                    room.date = self.completedRooms[index].date
                    self.rooms.append(room)
                    self.dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.rooms = self.rooms.sorted { $0.date > $1.date }
            self.tableView.reloadData()
            self.loadingView.removeFromSuperview()
        })
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currentId = Auth.auth().currentUser?.uid
        
        
        if userID != currentId, let id = currentId {
            userID = id
            query = Firestore.firestore().collection("completed").whereField("userId", isEqualTo: id)
        } else if userID != currentId, currentId == nil {
            userID = nil
            query = nil
        }
        
        observeQuery()

        if Auth.auth().currentUser?.uid != nil {
            userNotLoggedViewController.remove()
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
            add(userNotLoggedViewController)
            view.bringSubviewToFront(userNotLoggedViewController.view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
    
    deinit {
        listener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Completed"
        view.backgroundColor = UIColor.appBackgroundColor
        view.addSubview(tableView)
        configureTableView()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            tableView.isHidden = true
            add(userNotLoggedViewController)
            view.bringSubviewToFront(userNotLoggedViewController.view)
            return
        }
        tableView.isHidden = false
        view.addSubview(loadingView)
        query = Firestore.firestore().collection("completed").whereField("userId", isEqualTo: userId)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.appBackgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompletedCell")
    }
}


extension CompletedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell", for: indexPath)
        cell.backgroundColor = UIColor.cellBackgroundColor
        cell.textLabel?.textColor = .white
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = rooms[indexPath.row].name
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EscapeRoomDetailViewController()
        let room = rooms[indexPath.row]
        vc.documentIds = DocumentIds(business: room.businessId, room: room.documentId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
