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
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap))
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(room: Room) {
        titleLabel.text = room.name
        
        thumbnailImageView.image = UIImage(named: room.image)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 90),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 90)
            ])
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            ])
        
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
}

