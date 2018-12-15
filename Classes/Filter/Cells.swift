//
//  DetailCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 10/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//
import UIKit

class DetailCell: UITableViewCell {
    static let identifier = "DetailCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.cellBackgroundColor
        textLabel?.textColor = .white
        selectionStyle = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ClearAllCell: UITableViewCell {
    static let identifier = "ClearAllCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textAlignment = .center
        backgroundColor = UIColor.cellBackgroundColor
        textLabel?.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        selectedBackgroundView = backgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
