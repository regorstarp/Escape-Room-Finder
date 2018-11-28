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
    
    var delegate: ThumbnailDelegate?
    
    private var roomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func configure(image: UIImage?) {
        roomImageView.image = image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap))
        roomImageView.addGestureRecognizer(tapRecognizer)
        addSubview(roomImageView)
        NSLayoutConstraint.activate([
            roomImageView.topAnchor.constraint(equalTo: topAnchor),
            roomImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            roomImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roomImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roomImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func onImageTap() {
        delegate?.onTap(image: roomImageView.image)
    }
    
}
