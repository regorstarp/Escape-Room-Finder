//
//  LoadingScreen.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 03/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = UIActivityIndicatorView.Style.whiteLarge
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.appBackgroundColor
        addSubview(activityIndicator)
        activityIndicator.center = center
        activityIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
