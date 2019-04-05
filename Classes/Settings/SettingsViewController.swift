//
//  Account.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 20/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth
import WhatsNew

class SettingsViewController: UIViewController {
    
    fileprivate enum SettingsRows: Int, CaseIterable {
        case account
        case functionalities
    }
    
    private let authUI = FUIAuth.defaultAuthUI()!
    private var isUserLoggedIn : Bool {
        get {
            return Auth.auth().currentUser == nil ? false : true
        }
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        authUI.delegate = self
        view.backgroundColor = UIColor.appBackgroundColor
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.appBackgroundColor
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    
    
    func accountRowSelected() {
        if isUserLoggedIn {
            let accountViewController = FUIAccountSettingsViewController.init(authUI: authUI)
            navigationController?.pushViewController(accountViewController, animated: true)
        } else {
            presentAuthViewController()
        }
    }
    
    func functionalitiesRowSelected() {
        let whatsNew = WhatsNewViewController(items: [
            WhatsNewItem.image(title: "Explore", subtitle: "Find your new Escape Room adventure", image: UIImage(named: "room-logo")!),
            WhatsNewItem.image(title: "Complete", subtitle: "Keep a list of your completed rooms", image: UIImage(named: "completed-logo")!),
            WhatsNewItem.image(title: "Save", subtitle: "Save your favourite rooms", image: UIImage(named: "bookmark-logo")!)
            ])
        whatsNew.titleText = "Escape Room Finder"
        whatsNew.titleColor = .white
        whatsNew.view.backgroundColor = UIColor.appBackgroundColor
        whatsNew.itemSubtitleColor = .darkGray
        whatsNew.itemTitleColor = .white
        whatsNew.buttonText = "Continue"
        whatsNew.buttonTextColor = .white
        whatsNew.buttonBackgroundColor = #colorLiteral(red: 0.1869132817, green: 0.4777054191, blue: 1, alpha: 1)
        present(whatsNew, animated: true)
    }
    
    private func presentAuthViewController() {
        present(authUI.authViewController(), animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let settingsRows = SettingsRows(rawValue: indexPath.row) else { return UITableViewCell() }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Identifier")
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.cellBackgroundColor
        cell.textLabel?.textColor = .white
        switch settingsRows {
        case .account:
            cell.textLabel?.text = "Account"
            cell.detailTextLabel?.text = Auth.auth().currentUser?.displayName ?? "Add Account"
            return cell
        case .functionalities:
            cell.textLabel?.text = "Functionalities"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let settingsRows = SettingsRows(rawValue: indexPath.row) else { return }
        
        switch settingsRows {
        case .account:
            accountRowSelected()
        case .functionalities:
            functionalitiesRowSelected()
        }
    }
}

extension SettingsViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let err = error {
            print(err.localizedDescription)
        } else {
            tableView.reloadData()
        }
    }
    
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
        
        guard error == nil else { return }
        
        if operation == .deleteAccount || operation == .signOut {
            
            navigationController?.popViewController(animated: true)
            tableView.reloadData()
        }
    }
    
}
