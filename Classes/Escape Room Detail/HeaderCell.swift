//
//  HeaderCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 25/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    
    static let identifier = "HeaderCell"
    let kHeight: CGFloat = 20
    let leadingMargin: CGFloat = 16
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Escape Room"
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ut posuere massa. Proin elit nisl, laoreet eget ante eu, tincidunt condimentum magna. Phasellus aliquet nisi vitae accumsan semper. Vivamus vel sollicitudin augue. Integer dapibus turpis eu viverra sollicitudin. Morbi nec consectetur urna. Quisque interdum mauris quis pellentesque pellentesque. Aliquam pretium."
        label.numberOfLines = 0
        return label
    }()
    
    private var ratingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "filledStar")
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private var ratingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4/5"
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var durationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "clock")
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "60m"
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var numberOfPlayersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "players")
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private var numberOfPlayersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2-5"
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var callButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Call", for: .normal)
        button.setImage(UIImage(named: "directions"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
//        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.backgroundColor = #colorLiteral(red: 0.9178028703, green: 0.915073812, blue: 0.9110260606, alpha: 1)
        return button
    }()
    
    func configure() {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin)
            ])
        
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingMargin)
            ])
        
        addSubview(ratingsImageView)
        
        NSLayoutConstraint.activate([
            ratingsImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            ratingsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
//            ratingsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        
        addSubview(ratingsLabel)
        
        NSLayoutConstraint.activate([
            ratingsLabel.topAnchor.constraint(equalTo: ratingsImageView.topAnchor),
            ratingsLabel.leadingAnchor.constraint(equalTo: ratingsImageView.trailingAnchor, constant: 4),
            ratingsLabel.bottomAnchor.constraint(equalTo: ratingsImageView.bottomAnchor)
            ])
        
        addSubview(durationImageView)
        
        NSLayoutConstraint.activate([
            durationImageView.topAnchor.constraint(equalTo: ratingsImageView.topAnchor),
            durationImageView.leadingAnchor.constraint(equalTo: ratingsLabel.trailingAnchor, constant: 8),
            durationImageView.bottomAnchor.constraint(equalTo: ratingsImageView.bottomAnchor)
            ])
        
        addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: ratingsImageView.topAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationImageView.trailingAnchor, constant: 4),
            durationLabel.bottomAnchor.constraint(equalTo: ratingsImageView.bottomAnchor)
            ])
        
        addSubview(numberOfPlayersImageView)
        
        NSLayoutConstraint.activate([
            numberOfPlayersImageView.topAnchor.constraint(equalTo: ratingsImageView.topAnchor),
            numberOfPlayersImageView.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 8),
            numberOfPlayersImageView.bottomAnchor.constraint(equalTo: ratingsImageView.bottomAnchor)
            ])
        
        addSubview(numberOfPlayersLabel)
        
        NSLayoutConstraint.activate([
            numberOfPlayersLabel.topAnchor.constraint(equalTo: ratingsImageView.topAnchor),
            numberOfPlayersLabel.leadingAnchor.constraint(equalTo: numberOfPlayersImageView.trailingAnchor, constant: 4),
            numberOfPlayersLabel.bottomAnchor.constraint(equalTo: ratingsImageView.bottomAnchor)
            ])
        
        addSubview(callButton)
        
        NSLayoutConstraint.activate([
            callButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            callButton.heightAnchor.constraint(equalTo: callButton.widthAnchor, multiplier: 0.3),
            callButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            callButton.topAnchor.constraint(equalTo: ratingsImageView.bottomAnchor, constant: 8),
            callButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
