//
//  ActionsCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 26/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import MapKit

class ActionsCell: UITableViewCell {
    
    static let identifier = "ActionsCell"
    
    private var phoneNumber: Int?
    private var mailAddress: String?
    private var coordinate: CLLocationCoordinate2D?
    private var website: String?
    private var name: String?
    
    private var callButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Call", for: .normal)
        button.setImage(UIImage(named: "phone"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.9178028703, green: 0.915073812, blue: 0.9110260606, alpha: 1)
        return button
    }()
    
    private var mailButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Mail", for: .normal)
        button.setImage(UIImage(named: "mail"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.9178028703, green: 0.915073812, blue: 0.9110260606, alpha: 1)
        return button
    }()
    
    private var websiteButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Website", for: .normal)
        button.setImage(UIImage(named: "website"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
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
    
    func configure(name: String, phone: Int, mail: String, coordinate: CLLocationCoordinate2D, website: String) {
        self.name = name
        phoneNumber = phone
        mailAddress = mail
        self.coordinate = coordinate
        self.website = website
    }
    
    private func configureButtons() {
        directionsButton.addTarget(self, action: #selector(onDirectionsButtonPressed), for: .touchUpInside)
        websiteButton.addTarget(self, action: #selector(onWebsiteButtonPressed), for: .touchUpInside)
        mailButton.addTarget(self, action: #selector(onMailButtonPressed), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(onCallButtonPressed), for: .touchUpInside)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureButtons()
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
    
    @objc func onMailButtonPressed() {
        guard let email = mailAddress else { return }
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func onWebsiteButtonPressed() {
        guard let website = website, let url = URL(string: website) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func onCallButtonPressed() {
        guard let phoneNumber = phoneNumber,
            let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func onDirectionsButtonPressed() {
        guard let coordinate = coordinate else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    
}
