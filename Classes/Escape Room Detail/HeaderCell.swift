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
    
    private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    private var rateButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "filledStar"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 4
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "bookmark-button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 4
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    private var completeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "complete-button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 4
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
            ratingsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin)
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
        
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: ratingsImageView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingMargin)
            ])
        
        let stackView = UIStackView(arrangedSubviews: [rateButton, completeButton, saveButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingMargin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingMargin),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
            ])
        
        rateButton.addTarget(self, action: #selector(onRateButtonPressed), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(onCompleteButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(onSaveButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Button actions
    
    @objc func onRateButtonPressed() {
        UIView.transition(with: rateButton, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.rateButton.layer.backgroundColor =  #colorLiteral(red: 0.9411764706, green: 0.3176470588, blue: 0.03529411765, alpha: 1)
            self.rateButton.tintColor = .white
        }, completion: nil)
    }
    
    @objc func onSaveButtonPressed() {
        UIView.transition(with: saveButton, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.saveButton.layer.backgroundColor =  #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.saveButton.tintColor = .white
        }, completion: nil)
    }
    
    @objc func onCompleteButtonPressed() {
        UIView.transition(with: completeButton, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.completeButton.layer.backgroundColor =  #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            self.completeButton.tintColor = .white
        }, completion: nil)
    }
}
