//
//  EscapeRoomDetailViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 25/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

private enum RoomDetailRows: Int {
    case image
    case header
    case actions
    case address
    case mail
    case phone
    case website
    case count
}

class EscapeRoomDetailViewController: UIViewController {
    
    var business: Business!
    var room: Room!
    var documentIds: DocumentIds!
    var completed: Bool = false
    var completedDocumentId: String!
    var saved: Bool = false
    var savedDocumentId: String!
    var rated: Bool = false
    var ratedDocumentId: String!
    var userId: String?
    
//    private var expandedHeader = true
    private lazy var tableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
    
    private lazy var activityIndicatorContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = UIActivityIndicatorView.Style.gray
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    var bookmarkItem: UIBarButtonItem!
    var ratedItem: UIBarButtonItem!
    var completedItem: UIBarButtonItem!
    
    
    let dispatchGroup = DispatchGroup()
    
    private func resetVariables() {
        saved = false
        rated = false
        completed = false
        savedDocumentId = ""
        ratedDocumentId = ""
        completedDocumentId = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userId != Auth.auth().currentUser?.uid {
            //user changed account or signed out
            userId = Auth.auth().currentUser?.uid
            resetVariables()
            
            if userId == nil {
                setupNavigationBar()
            } else {
                showActivityIndicator()
                checkUserCompletedRoom()
                checkUserRatedRoom()
                checkUserSavedRoom()
                dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    self.setupNavigationBar()
                    self.hideActivityIndicator()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        userId = Auth.auth().currentUser?.uid
        showActivityIndicator()
        loadBusiness()
        loadRoom()
        
        if Auth.auth().currentUser?.uid != nil {
            checkUserCompletedRoom()
            checkUserRatedRoom()
            checkUserSavedRoom()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.setupNavigationBar()
            self.configureTableView()
            self.hideActivityIndicator()
        })
    }
    
    //check if user has the completed the room
    private func checkUserCompletedRoom() {
        guard let userId = userId else { return }
        
        dispatchGroup.enter()
        let ref = Firestore.firestore().collection("completed").whereField("roomId", isEqualTo: documentIds.room).whereField("userId", isEqualTo: userId)
        ref.getDocuments { [unowned self] (documents, error) in
            if let documents = documents, let document = documents.documents.first {
                self.completedDocumentId = document.documentID
                self.completed = true
            } else {
                print("User doesn't have this room completed")
                self.completed = false
            }
            self.dispatchGroup.leave()
        }
    }
    
    //check if user has saved the room
    private func checkUserSavedRoom() {
        guard let userId = userId else { return }
        
        dispatchGroup.enter()
        let ref = Firestore.firestore().collection("saved").whereField("roomId", isEqualTo: documentIds.room).whereField("userId", isEqualTo: userId)
        ref.getDocuments { [unowned self] (documents, error) in
            if let documents = documents, let document = documents.documents.first {
                self.savedDocumentId = document.documentID
                self.saved = true
            } else {
                print("User doesn't have this room saved")
                self.saved = false
            }
            self.dispatchGroup.leave()
        }
    }
    
    //check if user has rated the room
    private func checkUserRatedRoom() {
        dispatchGroup.enter()
        let ref = Firestore.firestore().collection("ratings").whereField("roomId", isEqualTo: documentIds.room)
        ref.getDocuments { [unowned self] (documents, error) in
            if let documents = documents, let document = documents.documents.first {
                self.ratedDocumentId = document.documentID
                self.rated = true
            } else {
                self.rated = false
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func loadBusiness() {
        dispatchGroup.enter()
        let ref = Firestore.firestore().collection("business").document(documentIds.business)
        ref.getDocument { [unowned self] (document, error) in
            if let document = document, document.exists, let dict = document.data() , let business = Business(dictionary: dict) {
                self.business = business
            } else {
                fatalError("Room with id: \(self.documentIds.room) doesn't exist")
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func loadRoom() {
        dispatchGroup.enter()
        let ref = Firestore.firestore().collection("room").document(documentIds.room)
        ref.getDocument { [unowned self] (document, error) in
            if let document = document, document.exists, let dict = document.data() , let room = Room(dictionary: dict, documentId: document.documentID) {
                self.room = room
            } else {
                fatalError("Room with id: \(self.documentIds.room) doesn't exist")
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageViewCell.self, forCellReuseIdentifier: ImageViewCell.identifier)
        tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.identifier)
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: SubtitleCell.identifier)
        tableView.register(ActionsCell.self, forCellReuseIdentifier: ActionsCell.identifier)
    }
    
    private func setupNavigationBar() {
        
        if saved {
            bookmarkItem = UIBarButtonItem(image: UIImage(named: "bookmark-filled"), style: .plain, target: self, action: #selector(removeBookmark(sender:)))
        } else {
            bookmarkItem = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(addBookmark(sender:)))
        }
        
        
        if completed {
            completedItem = UIBarButtonItem(image: UIImage(named: "complete-button-selected"), style: .plain, target: self, action: #selector(removeCompleted(sender:)))
        } else {
            completedItem = UIBarButtonItem(image: UIImage(named: "complete-button"), style: .plain, target: self, action: #selector(addCompleted(sender:)))
        }
        
        if rated {
            ratedItem = UIBarButtonItem(image: UIImage(named: "filledStar"), style: .plain, target: self, action: #selector(removeRated(sender:)))
        } else {
          ratedItem = UIBarButtonItem(image: UIImage(named: "emptyStar"), style: .plain, target: self, action: #selector(addRated(sender:)))
        }
    
        navigationItem.rightBarButtonItems = [ratedItem ,completedItem, bookmarkItem]
    }
    
    @objc private func addRated(sender: UIBarButtonItem) {
        sender.action = #selector(removeRated(sender:))
        sender.image = UIImage(named: "filledStar")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc private func removeRated(sender: UIBarButtonItem) {
        sender.action = #selector(addRated(sender:))
        sender.image = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc private func addCompleted(sender: UIBarButtonItem) {
        
        guard userId != nil else {
            showSignInAlert(forAction: "Complete")
            return
        }
        
        sender.action = #selector(removeCompleted(sender:))
        sender.image = UIImage(named: "complete-button-selected")?.withRenderingMode(.alwaysTemplate)
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let roomId = room.documentId
        let ref = Firestore.firestore().collection("completed").document()
        
        let completedRoomModel = CompletedRoom(userId: userId, roomId: roomId)
        ref.setData(completedRoomModel.documentData()) { error in
            if let error = error {
                print("Error saving room as completed: \(error)")
            } else {
                self.completedDocumentId = ref.documentID
            }
        }
    }
    
    @objc private func removeCompleted(sender: UIBarButtonItem) {
        sender.action = #selector(addCompleted(sender:))
        sender.image = UIImage(named: "complete-button")?.withRenderingMode(.alwaysTemplate)
        
        Firestore.firestore().collection("completed").document(completedDocumentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    @objc private func addBookmark(sender: UIBarButtonItem) {
        
        guard userId != nil else {
            showSignInAlert(forAction: "Save")
            return
        }
        
        sender.action = #selector(removeBookmark(sender:))
        sender.image = UIImage(named: "bookmark-filled")?.withRenderingMode(.alwaysTemplate)
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let roomId = room.documentId
        let ref = Firestore.firestore().collection("saved").document()
        
        let completedRoomModel = CompletedRoom(userId: userId, roomId: roomId)
        ref.setData(completedRoomModel.documentData()) { error in
            if let error = error {
                print("Error saving room as saved: \(error)")
            } else {
                self.savedDocumentId = ref.documentID
            }
        }
    }
    
    @objc private func removeBookmark(sender: UIBarButtonItem) {
        sender.action = #selector(addBookmark(sender:))
        sender.image = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
        
        Firestore.firestore().collection("saved").document(savedDocumentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
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

extension EscapeRoomDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomDetailRows.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let roomDetailRow = RoomDetailRows(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch roomDetailRow {
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageViewCell.identifier, for: indexPath) as? ImageViewCell else { return UITableViewCell() }
            cell.configure(image: UIImage(named: room.image))
            cell.delegate = self
            return cell
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as? HeaderCell else { return UITableViewCell() }
            cell.configure(room: room)
            return cell
        case .actions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionsCell.identifier, for: indexPath) as? ActionsCell else { return UITableViewCell() }
            cell.configure(room: room)
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.identifier, for: indexPath)
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = business.address
            return cell
        case .phone:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.identifier, for: indexPath)
            cell.textLabel?.text = "Phone"
            cell.detailTextLabel?.text = "\(business.phone)"
            return cell
        case .mail:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.identifier, for: indexPath)
            cell.textLabel?.text = "Mail"
            cell.detailTextLabel?.text = "\(business.mail)"
            return cell
        case .website:
            let cell = tableView.dequeueReusableCell(withIdentifier: SubtitleCell.identifier, for: indexPath)
            cell.textLabel?.text = "Website"
            cell.detailTextLabel?.text = "\(business.website)"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.row == RoomDetailRows.header.rawValue {
//            tableView.beginUpdates()
//            expandedHeader = !expandedHeader
//            tableView.endUpdates()
//        }
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard indexPath.row == RoomDetailRows.header.rawValue else { return UITableView.automaticDimension }
//        if expandedHeader {
//            return UITableView.automaticDimension
//        } else {
//            return 100
//        }
//    }
    
}

extension EscapeRoomDetailViewController: ThumbnailDelegate {
    func onTap(image: UIImage?) {
        let imageViewController = ImageViewController()
        imageViewController.image = image
        present(UINavigationController(rootViewController: imageViewController), animated: true)
    }
}
