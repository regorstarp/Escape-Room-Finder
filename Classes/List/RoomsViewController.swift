//
//  RoomsViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 14/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseStorage

class RoomsViewController: UICollectionViewController {
    private var flowLayout = ColumnFlowLayout()
    private let detailViewController = EscapeRoomDetailViewController()
   
    var rooms: [Room] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCollectionView()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCell.identifier, for: indexPath) as? RoomCell
            else { preconditionFailure("Failed to load collection view cell") }
        cell.room = rooms[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        detailViewController.documentIds = DocumentIds(business: room.businessId, room: room.documentId)
        parent?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: UI Helper Methods
    
    func prepareCollectionView() {
        
        
        
        // Set up the collection view.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor.appBackgroundColor
        collectionView.alwaysBounceVertical = true
//        collectionView.indicatorStyle = .white
        collectionView.register(RoomCell.self, forCellWithReuseIdentifier: RoomCell.identifier)
        
    }

}
