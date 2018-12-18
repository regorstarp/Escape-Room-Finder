//
//  SubtitleCell.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 26/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

class SubtitleCell: UITableViewCell {
    static let identifier = "SubtitleCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .white
        textLabel?.textColor = .white
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1019638271)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
