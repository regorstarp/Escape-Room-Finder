//
//  HeaderCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 25/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import Foundation

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
        imageView.tintColor = UIColor.gray
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private var ratingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1.6"
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textColor = UIColor.gray
        return label
    }()
    
    private var durationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "timer")
        imageView.tintColor = UIColor.gray
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "60m"
        label.textColor = UIColor.gray
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var numberOfPlayersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "users")
        imageView.tintColor = UIColor.gray
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private var numberOfPlayersLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2-5"
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    func configure(room: Room) {
        
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
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingMargin)
            ])
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .horizontal
        
        let rateDouble = 1.6
        
        func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage? {
            if rating >= starNumber {
                return UIImage(named: "filledStar")
            } else if rating + 0.5 >= starNumber {
                return UIImage(named: "halfStar")
            } else {
                return UIImage(named: "emptyStar")
            }
        }
        
        for i in 0..<5 {
            let ratingsImageView = UIImageView()
            ratingsImageView.translatesAutoresizingMaskIntoConstraints = false
            ratingsImageView.image = getStarImage(starNumber: Double(i + 1), forRating: rateDouble)
            ratingsImageView.tintColor = UIColor.gray
            ratingsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            ratingsImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            stackView.addArrangedSubview(ratingsImageView)
        }
        
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        
        addSubview(ratingsLabel)

        NSLayoutConstraint.activate([
            ratingsLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            ratingsLabel.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 4),
            ratingsLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])

        addSubview(durationImageView)

        NSLayoutConstraint.activate([
            durationImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            durationImageView.leadingAnchor.constraint(equalTo: ratingsLabel.trailingAnchor, constant: 8),
            durationImageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])

        addSubview(durationLabel)

        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationImageView.trailingAnchor, constant: 4),
            durationLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])

        addSubview(numberOfPlayersImageView)

        NSLayoutConstraint.activate([
            numberOfPlayersImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            numberOfPlayersImageView.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 8),
            numberOfPlayersImageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])

        addSubview(numberOfPlayersLabel)

        NSLayoutConstraint.activate([
            numberOfPlayersLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            numberOfPlayersLabel.leadingAnchor.constraint(equalTo: numberOfPlayersImageView.trailingAnchor, constant: 4),
            numberOfPlayersLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

