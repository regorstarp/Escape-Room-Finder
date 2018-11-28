//
//  ActionsCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 26/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class ActionsCell: UITableViewCell {
    
    static let identifier = "ActionsCell"
    
    private var callButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Call", for: .normal)
        button.setImage(UIImage(named: "phone"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = #colorLiteral(red: 0.9178028703, green: 0.915073812, blue: 0.9110260606, alpha: 1)
        return button
    }()
    
    private var mailButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Mail", for: .normal)
        button.setImage(UIImage(named: "mail"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = #colorLiteral(red: 0.9178028703, green: 0.915073812, blue: 0.9110260606, alpha: 1)
        return button
    }()
    
    private var websiteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Website", for: .normal)
        button.setImage(UIImage(named: "website"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = #colorLiteral(red: 0.9178028703, green: 0.915073812, blue: 0.9110260606, alpha: 1)
        return button
    }()
    
    private var directionsButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.1869132817, green: 0.4777054191, blue: 1, alpha: 1)
        button.tintColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    func configure(room: Room) {
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(directionsButton)
        
        NSLayoutConstraint.activate([
            directionsButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            directionsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            directionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        
        let actionsStackView = UIStackView(arrangedSubviews: [callButton, mailButton, websiteButton])
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 8
        actionsStackView.distribution = .fillEqually
        
        addSubview(actionsStackView)
        
        NSLayoutConstraint.activate([
            actionsStackView.topAnchor.constraint(equalTo: directionsButton.bottomAnchor, constant: 16),
            actionsStackView.leadingAnchor.constraint(equalTo: directionsButton.leadingAnchor),
            actionsStackView.trailingAnchor.constraint(equalTo: directionsButton.trailingAnchor),
            actionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            actionsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
