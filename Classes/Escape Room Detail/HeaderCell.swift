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
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var ratingCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private var ratingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .horizontal
        return stackView
    }()
    
    func configure(room: Room) {
        numberOfPlayersLabel.text = "2-\(room.maxPlayers)"
        durationLabel.text = "\(room.duration)m"
        ratingsLabel.text = "\(room.averageRating)"
        descriptionLabel.text = room.description
        titleLabel.text = room.name
        configureRatings(forRating: room.averageRating)
        priceLabel.text = room.price
        if room.ratingCount > 1 {
            ratingCountLabel.text = "\(room.ratingCount) Ratings"
        } else {
            ratingCountLabel.text = "\(room.ratingCount) Rating"
        }
        
        categoryLabel.text = room.categories.joined(separator: " ")
    }
    
    private func configureRatings(forRating rating: Float) {
        let rateDouble = rating
        ratingsStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
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
            ratingsImageView.image = getStarImage(starNumber: Double(i + 1), forRating: Double(rateDouble))
            ratingsImageView.tintColor = UIColor.gray
            ratingsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            ratingsImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            ratingsStackView.addArrangedSubview(ratingsImageView)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1019638271)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            categoryLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
            ])
        
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingMargin)
            ])

        addSubview(ratingsStackView)

        NSLayoutConstraint.activate([
            ratingsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            ratingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin)
            ])
        
        addSubview(ratingsLabel)

        NSLayoutConstraint.activate([
            ratingsLabel.topAnchor.constraint(equalTo: ratingsStackView.topAnchor),
            ratingsLabel.leadingAnchor.constraint(equalTo: ratingsStackView.trailingAnchor, constant: 4),
            ratingsLabel.bottomAnchor.constraint(equalTo: ratingsStackView.bottomAnchor)
            ])

        addSubview(durationImageView)

        NSLayoutConstraint.activate([
            durationImageView.topAnchor.constraint(equalTo: ratingsStackView.topAnchor),
            durationImageView.leadingAnchor.constraint(equalTo: ratingsLabel.trailingAnchor, constant: 8),
            durationImageView.bottomAnchor.constraint(equalTo: ratingsStackView.bottomAnchor)
            ])

        addSubview(durationLabel)

        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: ratingsStackView.topAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationImageView.trailingAnchor, constant: 4),
            durationLabel.bottomAnchor.constraint(equalTo: ratingsStackView.bottomAnchor)
            ])

        addSubview(numberOfPlayersImageView)

        NSLayoutConstraint.activate([
            numberOfPlayersImageView.topAnchor.constraint(equalTo: ratingsStackView.topAnchor),
            numberOfPlayersImageView.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 8),
            numberOfPlayersImageView.bottomAnchor.constraint(equalTo: ratingsStackView.bottomAnchor)
            ])

        addSubview(numberOfPlayersLabel)

        NSLayoutConstraint.activate([
            numberOfPlayersLabel.topAnchor.constraint(equalTo: ratingsStackView.topAnchor),
            numberOfPlayersLabel.leadingAnchor.constraint(equalTo: numberOfPlayersImageView.trailingAnchor, constant: 4),
            ])
        
        addSubview(ratingCountLabel)
        
        NSLayoutConstraint.activate([
            ratingCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            ratingCountLabel.leadingAnchor.constraint(equalTo: ratingsStackView.leadingAnchor),
            ratingCountLabel.topAnchor.constraint(equalTo: ratingsStackView.bottomAnchor, constant: 4)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

