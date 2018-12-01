//
//  RateView.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 01/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class RateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let ratingControl = RatingControl()
        ratingControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ratingControl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
