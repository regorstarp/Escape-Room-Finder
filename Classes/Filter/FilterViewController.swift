//
//  FilterViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 28/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

enum FilterRows: Int, CaseIterable {
    case category
    case city
    case difficulty
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    
    private lazy var tableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
    
//    private let sortByOptions = ["name", "category", "city", "price", "avgRating"]
    private let difficultyOptions = ["Easy", "Medium", "Hard"]
    private let cityOptions = ["Barcelona","Sabadell"]
    private let categoryOptions = ["Adventure", "Investigation"]
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PickerViewCell.self, forCellReuseIdentifier: PickerViewCell.identifier)
    }
    
    private func configureNavigationBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func onCancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func onDoneButtonPressed() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        configureNavigationBarButtons()
        configureTableView()
    }
    
}

protocol FilterViewControllerDelegate: NSObjectProtocol {
    func controller(_ controller: FilterViewController, didSelectCategory category: String?, city: String?, numberOfPlayers: Int?, difficulty: Int?)
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PickerViewCell.identifier, for: indexPath) as? PickerViewCell, let filterRows = FilterRows(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch filterRows {
        case .category:
            cell.configure(options: categoryOptions, title: "Category")
        case .city:
            cell.configure(options: cityOptions, title: "City")
        case .difficulty:
            cell.configure(options: difficultyOptions, title: "Difficulty")
        }
        
        return cell
    }
    
    
}
