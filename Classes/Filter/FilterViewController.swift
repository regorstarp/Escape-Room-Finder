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
    
    private func difficulty(from string: String) -> Int? {
        switch string {
        case "Easy":
            return 0
        case "Medium":
            return 1
        case "Hard":
            return 2
            
        case _:
            return nil
        }
    }
    
    @objc private func onCancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func onDoneButtonPressed() {
        
        let categoryIndexPath = IndexPath(row: FilterRows.category.rawValue, section: 0)
        let cityIndexPath = IndexPath(row: FilterRows.city.rawValue, section: 0)
        let difficultyIndexPath = IndexPath(row: FilterRows.difficulty.rawValue, section: 0)
        guard let categoryCell = tableView.cellForRow(at: categoryIndexPath) as? PickerViewCell, let cityCell = tableView.cellForRow(at: cityIndexPath) as? PickerViewCell, let difficultyCell = tableView.cellForRow(at: difficultyIndexPath) as? PickerViewCell else { return }
        
        let difficulty = difficultyCell.textField.text.flatMap { self.difficulty(from: $0) }
        delegate?.controller(self, didSelectCategory: categoryCell.textField.text, city: cityCell.textField.text, difficulty: difficulty)
        navigationController?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        configureNavigationBarButtons()
        configureTableView()
    }
    
}

protocol FilterViewControllerDelegate: NSObjectProtocol {
    func controller(_ controller: FilterViewController, didSelectCategory category: String?, city: String?, difficulty: Int?)
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
