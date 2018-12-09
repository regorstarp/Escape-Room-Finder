//
//  SearchResultsViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 09/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    var rooms = [Room]() {
        didSet {
            
        }
    }
    var filteredRooms = [Room]()
    private let identifier = "SearchResultCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

         cell.textLabel?.text = filteredRooms[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = EscapeRoomDetailViewController()
        let room = filteredRooms[indexPath.row]
        detailVC.documentIds = DocumentIds(business: room.businessId, room: room.documentId)
        presentingViewController?.navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension SearchResultsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
//    func searchBarIsEmpty() -> Bool {
//        // Returns true if the text is empty or nil
//        return true
////        return searchController.searchBar.text?.isEmpty ?? true
//    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredRooms = rooms.filter({( room : Room) -> Bool in
            return room.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
