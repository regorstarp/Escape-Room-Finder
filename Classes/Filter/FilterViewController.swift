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
    case players
}

class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    private var filterManager = FilterManager()
    
    private lazy var filterTableView = UITableView(frame: view.bounds, style: .grouped)
    
    private var selectedRowIndexPath: IndexPath?
    
    private func configureTableView() {
        view.addSubview(filterTableView)
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
        filterTableView.register(Test.self, forCellReuseIdentifier: Test.identifier)
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
        updateFilters()
        navigationController?.dismiss(animated: true)
    }
    
    private func updateFilters() {
        var difficultyFilter: Int?
        if let filter = filterManager.difficulty.getFilter() {
            difficultyFilter = difficulty(from: filter)
        }
        var playersFilter: Int?
        if let playersString = filterManager.players.getFilter(), let players = Int(playersString) {
            playersFilter = players
        }
        
        delegate?.controller(self, didSelectCategory: filterManager.category.getFilter(), city: filterManager.city.getFilter(), difficulty: difficultyFilter, players: playersFilter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        configureNavigationBarButtons()
        configureTableView()
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return FilterRows.allCases.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: Test.identifier, for: indexPath)
            cell.textLabel?.text = "Clear All"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            
            cell.textLabel?.text = filterManager.getName(forFilter: indexPath.row)
            cell.detailTextLabel?.text = filterManager.getSelectedOption(forFilter: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            selectedRowIndexPath = nil
            filterManager.resetFilters()
            updateFilters()
            tableView.reloadData()
            navigationController?.dismiss(animated: true)
            return
        }
        
        selectedRowIndexPath = indexPath
        
        guard let filter = filterManager.getFilter(indexPath.row) else { return }
        
        let filterOptionsViewController = FilterOptionsTableViewController()
        filterOptionsViewController.filter = filter
        filterOptionsViewController.delegate = self
        navigationController?.pushViewController(filterOptionsViewController, animated: true)
    }
}

protocol FilterViewControllerDelegate: NSObjectProtocol {
    func controller(_ controller: FilterViewController, didSelectCategory category: String?, city: String?, difficulty: Int?, players: Int?)
}

extension FilterViewController: FilterOptionDelegate {
    func filterOptionSelected(_ option: Int) {

        guard let indexPath = selectedRowIndexPath else { return }
        
        filterManager.updateSelectedOption(option, forFilter: indexPath.row)
        
        filterTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
