//
//  FilterOptionsTableViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 10/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

protocol FilterOptionDelegate {
    func filterOptionSelected(_ option: Int)
}

class FilterOptionsTableViewController: UITableViewController {
    
    var delegate: FilterOptionDelegate?
    var filter: Filter?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filter = filter {
            return filter.options.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let filter = filter else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath)
        if indexPath.row == filter.selectedOption {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = filter.options[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.filterOptionSelected(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
