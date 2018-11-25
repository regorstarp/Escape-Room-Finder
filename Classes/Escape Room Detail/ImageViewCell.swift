//
//  ImageViewCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 25/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    static let identifier = "ImageViewCell"
    
    private var roomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func configure(imageName: String) {
        roomImageView.image = UIImage(named: imageName)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(roomImageView)
        NSLayoutConstraint.activate([
            roomImageView.topAnchor.constraint(equalTo: topAnchor),
            roomImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            roomImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roomImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(equalToConstant: 300)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
