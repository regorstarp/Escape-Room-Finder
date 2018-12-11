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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class Test: UITableViewCell {
    static let identifier = "TestCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textAlignment = .center
        textLabel?.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
