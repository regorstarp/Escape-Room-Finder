//
//  RatingViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 04/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

protocol RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didSendRating rating: Int)
}

class RatingView: UIView {
    
    var delegate: RatingViewDelegate?
    private lazy var ratingControl = RatingControl()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Rate"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(onCancelPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(onSendPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        backgroundColor = .white
        ratingControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingControl)
        addSubview(titleLabel)
        let buttonSeparator = UIView()
        buttonSeparator.backgroundColor = .gray
        buttonSeparator.translatesAutoresizingMaskIntoConstraints = false
        buttonSeparator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true

        let topSeparator = UIView()
        topSeparator.backgroundColor = .gray
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        addSubview(topSeparator)

        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, buttonSeparator, sendButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillProportionally
        addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ratingControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            ratingControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 43),
            topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeparator.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            buttonSeparator.centerXAnchor.constraint(equalTo: buttonStackView.centerXAnchor),
            buttonSeparator.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func onCancelPressed() {
        removeFromSuperview()
    }
    
    @objc func onSendPressed() {
        delegate?.ratingView(self, didSendRating: ratingControl.rating)
        removeFromSuperview()
    }
    
}
