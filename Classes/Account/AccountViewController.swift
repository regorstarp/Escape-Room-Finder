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

class AccountViewController: BaseViewController {
    
    fileprivate enum SettingsRows: Int {
        case account = 0
        case count
    }
    
    private let authUI = FUIAuth.defaultAuthUI()!
    private var isUserLoggedIn : Bool {
        get {
            return Auth.auth().currentUser == nil ? false : true
        }
    }
    
    private lazy var tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        authUI.delegate = self
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
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
            presentAccountRowSelectedAlert()
        }
    }
    
    func presentAccountRowSelectedAlert() {
        let alert = UIAlertController(title: "Add Account", message: "Add an account to access many more features of Escape Room Finder", preferredStyle: .alert)
        let signInAction = UIAlertAction(title: "Sign In", style: .default) { (action) in
            self.presentAuthViewController()
        }
        alert.addAction(signInAction)
        let createAccountAction = UIAlertAction(title: "Create Account", style: .default) { (action) in
            self.presentAuthViewController()
        }
        alert.addAction(createAccountAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func presentAuthViewController() {
        present(authUI.authViewController(), animated: true)
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsRows.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let settingsRows = SettingsRows(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch settingsRows {
        case .account:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Identifier")
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Account"
            cell.detailTextLabel?.text = Auth.auth().currentUser?.displayName ?? "Add Account"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingsRows = SettingsRows(rawValue: indexPath.row) else { return }
        
        switch settingsRows {
        case .account:
            accountRowSelected()
        default:
            break
        }
    }
}

extension AccountViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let err = error {
            print(err.localizedDescription)
        } else {
            tableView.reloadRows(at: [IndexPath(row: SettingsRows.account.rawValue, section: 0)], with: .automatic)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
        
        guard error == nil else { return }
        
        if operation == .deleteAccount || operation == .signOut {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
