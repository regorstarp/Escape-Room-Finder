//
//  EscapeRoomCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 24/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

protocol ThumbnailDelegate {
    func onTap(image: UIImage?)
}

class EscapeRoomCell: UITableViewCell {
    
    static let identifier = "EscapeRoomCell"
    var delegate: ThumbnailDelegate?
    
    let itemsTintColor: UIColor = .darkGray
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    private lazy var durationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = itemsTintColor
        return imageView
    }()
    
    private lazy var difficultyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "puzzle")
        imageView.tintColor = itemsTintColor
        return imageView
    }()
    
    private lazy var playersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "players")
        imageView.tintColor = itemsTintColor
        return imageView
    }()
    
    private lazy var difficultyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = itemsTintColor
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = itemsTintColor
        return label
    }()
    
    private lazy var playersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = itemsTintColor
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .horizontal
        return sv
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "more")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(onMoreButton), for: .touchUpInside)
        button.tintColor = tintColor
        return button
    }()
    
    func configure(room: Room) {
        titleLabel.text = room.name
        durationLabel.text = "\(room.duration)"
        playersLabel.text = "2-\(room.maxPlayers)"
        thumbnailImageView.image = UIImage(named: room.image)
        
        switch room.difficulty {
        case .easy:
            difficultyLabel.text = "Easy"
        case .medium:
            difficultyLabel.text = "Medium"
        case .hard:
            difficultyLabel.text = "Hard"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        addSubview(thumbnailImageView)
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60)
            ])
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            ])
        
        addSubview(durationImageView)
        addSubview(durationLabel)
        addSubview(playersImageView)
        addSubview(playersLabel)
        
        addSubview(stackView)
        stackView.addArrangedSubview(durationImageView)
        stackView.addArrangedSubview(durationLabel)
        stackView.addArrangedSubview(playersImageView)
        stackView.addArrangedSubview(playersLabel)
        
        let footerHeight: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: footerHeight)
            ])
        
        NSLayoutConstraint.activate([
            difficultyImageView.heightAnchor.constraint(equalToConstant: footerHeight),
            difficultyImageView.widthAnchor.constraint(equalToConstant: footerHeight),
            playersImageView.heightAnchor.constraint(equalToConstant: footerHeight),
            playersImageView.widthAnchor.constraint(equalToConstant: footerHeight),
            durationImageView.heightAnchor.constraint(equalToConstant: footerHeight),
            durationImageView.widthAnchor.constraint(equalToConstant: footerHeight)
            ])
        
//        let ratingControl = RatingControl()
//        ratingControl.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(ratingControl)
//        NSLayoutConstraint.activate([
//            ratingControl.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            ratingControl.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8),
//            ratingControl.heightAnchor.constraint(equalToConstant: 20)
//            ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        thumbnailImageView.sd_cancelCurrentImageLoad()
    }
    
    @objc func onImageTap() {
        delegate?.onTap(image: thumbnailImageView.image)
    }
    
    @objc func onMoreButton() {
        
    }
}
