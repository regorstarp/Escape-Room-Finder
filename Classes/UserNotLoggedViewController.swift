//
//  UserNotLoggedView.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 21/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth

class UserNotLoggedViewController: UIViewController {
    
    enum ScreenType {
        case completed
        case saved
        case account
    }
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to access your Escape Room Finder account, explore your next escape room, save rooms for later, check your previously played games and much more!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.1869132817, green: 0.4777054191, blue: 1, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(onSignInButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.tintColor = #colorLiteral(red: 0.6323309541, green: 0.6328232288, blue: 0.632407248, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Create Account", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onCreateAccountButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var imageName: String = ""
    private let authUI = FUIAuth.defaultAuthUI()!
    
    convenience init(imageName: String) {
        self.init()
        self.imageName = imageName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI.delegate = self
        
        view.addSubview(contentStackView)
        view.addSubview(logoImageView)
        contentStackView.addArrangedSubview(messageLabel)
        contentStackView.addArrangedSubview(signInButton)
        contentStackView.addArrangedSubview(createAccountButton)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            signInButton.heightAnchor.constraint(equalToConstant: 42),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.bottomAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
    }
    
    @objc private func onSignInButton() {
        present(authUI.authViewController(), animated: true)
    }
    
    @objc private func onCreateAccountButton() {
        present(authUI.authViewController(), animated: true)
    }
}

extension UserNotLoggedViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let err = error {
            print(err.localizedDescription)
        } else {
            remove()
        }
    }
}
