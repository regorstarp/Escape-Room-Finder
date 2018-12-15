//
//  RoomCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 15/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseStorage

class RoomCell: UICollectionViewCell {
    static let identifier = "kListCollectionViewCell"
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let bgView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        autoresizesSubviews = true
        
        backgroundColor = UIColor.appBackgroundColor
        layer.cornerRadius = 20
        
        bgView.frame = bounds
        bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1019638271)
        backgroundView = bgView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1021243579)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 54.0),
            imageView.heightAnchor.constraint(equalToConstant: 54.0),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            nameLabel.firstBaselineAnchor.constraint(equalTo: self.topAnchor, constant: 32.0),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override var isHighlighted: Bool {
        didSet {
            let duration = isHighlighted ? 0.45 : 0.4
            let transform = isHighlighted ?
                CGAffineTransform(scaleX: 0.96, y: 0.96) : CGAffineTransform.identity
            let bgColor = isHighlighted ?
                UIColor(white: 1.0, alpha: 0.2) : UIColor(white: 1.0, alpha: 0.1)
            let animations = {
                self.transform = transform
                self.bgView.backgroundColor = bgColor
            }
            
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: animations,
                           completion: nil)
        }
    }
    
    var room: Room? {
        didSet {
            guard let aRoom = room else { return }
            nameLabel.text = aRoom.name
            
            let ref = Storage.storage().reference(withPath: aRoom.image + ".jpg")
            ref.downloadURL { (url, error) in
                self.imageView.sd_setImage(with: url)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
    }
}
