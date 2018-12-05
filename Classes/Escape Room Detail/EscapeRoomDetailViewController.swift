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
    var userReview: Review?
    
    var roomReference: DocumentReference?
    
    private lazy var tableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
    private lazy var loadingView = LoadingView(frame: view.frame)
    
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
    
        view.addSubview(loadingView)
        resetVariables()
        
        if Auth.auth().currentUser?.uid == nil {
            setupNavigationBar()
        } else {
            view.addSubview(loadingView)
            loadBusiness()
            loadRoom()
            checkUserCompletedRoom()
            checkUserRatedRoom()
            checkUserSavedRoom()
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                self.setupNavigationBar()
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        configureTableView()
        
        if Auth.auth().currentUser?.uid == nil {
            setupNavigationBar()
        } else {
            view.addSubview(loadingView)
            loadBusiness()
            loadRoom()
            checkUserCompletedRoom()
            checkUserRatedRoom()
            checkUserSavedRoom()
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                self.setupNavigationBar()
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
            })
        }
    }
    
    //check if user has the completed the room
    private func checkUserCompletedRoom() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        dispatchGroup.enter()
        let ref = Firestore.firestore().collection("ratings").whereField("roomId", isEqualTo: documentIds.room).whereField("userId", isEqualTo: userId)
        ref.getDocuments { [unowned self] (documents, error) in
            if let documents = documents, let document = documents.documents.first, let review = Review(dictionary: document.data(), documentId: document.documentID) {
                self.userReview = review
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
        roomReference = Firestore.firestore().collection("room").document(documentIds.room)
        roomReference?.getDocument { [unowned self] (document, error) in
            if let document = document, document.exists, let dict = document.data() , let room = Room(dictionary: dict, documentId: document.documentID) {
                self.room = room
            } else {
                fatalError("Room with id: \(self.documentIds.room) doesn't exist")
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func configureTableView() {
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
            ratedItem = UIBarButtonItem()
            ratedItem.image = UIImage(named: "filledStar")
            ratedItem.isEnabled = false
        } else {
          ratedItem = UIBarButtonItem(image: UIImage(named: "emptyStar"), style: .plain, target: self, action: #selector(addRated(sender:)))
        }
    
        navigationItem.rightBarButtonItems = [ratedItem ,completedItem, bookmarkItem]
    }
    
    @objc private func addRated(sender: UIBarButtonItem) {
        
        let rating = RatingView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.85, height: 150))
        view.addSubview(rating)
        rating.center = view.center
        rating.delegate = self
        
//        sender.action = #selector(removeRated(sender:))
//        sender.image = UIImage(named: "filledStar")?.withRenderingMode(.alwaysTemplate)
        

    }
    
    private func addRatingTransaction(withRating rating: Int) {
        guard let reference = roomReference, let userId = Auth.auth().currentUser?.uid else { return }
        
        let review = Review.init(rating: rating, userId: userId, roomId: room.documentId, documentId: userReview?.documentId ?? "")
        
        let reviewsCollection = Firestore.firestore().collection("ratings")
        let reviewReference: DocumentReference
        if let userReview = userReview {
            reviewReference = reviewsCollection.document(userReview.documentId)
        } else {
            reviewReference = reviewsCollection.document()
        }
        
    
        let firestore = Firestore.firestore()
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in

            // Read data from Firestore inside the transaction, so we don't accidentally
            // update using stale client data. Error if we're unable to read here.
            let roomSnapshot: DocumentSnapshot
            do {
                try roomSnapshot = transaction.getDocument(Firestore.firestore().collection("room").document(self.room.documentId))
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            // Error if the restaurant data in Firestore has somehow changed or is malformed.
            guard let data = roomSnapshot.data(),
                let room = Room(dictionary: data, documentId: roomSnapshot.documentID) else {

                    let error = NSError(domain: "EscapeRoomFinderErrorDomain", code: 0, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to write to room at Firestore path: \(reference.path)"
                        ])
                    errorPointer?.pointee = error
                    return nil
            }
            
            // Update the restaurant's rating and rating count and post the new review at the
            // same time.
            let newAverage = (Float(room.ratingCount) * room.averageRating + Float(review.rating))
                / Float(room.ratingCount + 1)

            transaction.setData(review.dictionary, forDocument: reviewReference)
            transaction.updateData([
                "ratingCount": room.ratingCount + 1,
                "averageRating": newAverage
                ], forDocument: reference)
            return nil
        }) { (object, error) in
            if let error = error {
                print(error)
            } else {
                self.ratedItem.action = nil
                self.ratedItem.image = UIImage(named: "filledStar")?.withRenderingMode(.alwaysTemplate)
                self.ratedItem.isEnabled = false
            }

        }
    }
    
    @objc private func removeRated(sender: UIBarButtonItem) {
        sender.action = #selector(addRated(sender:))
        sender.image = UIImage(named: "emptyStar")?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc private func addCompleted(sender: UIBarButtonItem) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            showSignInAlert(forAction: "Complete")
            return
        }
        
        sender.action = #selector(removeCompleted(sender:))
        sender.image = UIImage(named: "complete-button-selected")?.withRenderingMode(.alwaysTemplate)

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
        
        guard let userId = Auth.auth().currentUser?.uid else {
            showSignInAlert(forAction: "Save")
            return
        }
        
        sender.action = #selector(removeBookmark(sender:))
        sender.image = UIImage(named: "bookmark-filled")?.withRenderingMode(.alwaysTemplate)
    
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
}

extension EscapeRoomDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard room != nil else { return 0 }
        
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

extension EscapeRoomDetailViewController: RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didSendRating rating: Int) {
        addRatingTransaction(withRating: rating)
    }
}
