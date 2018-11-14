//
//  BusinessDetailTableViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 14/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit

//private enum Row: Int {
//    case address
//    case mail
//    case phone
//    case website
//    case count
//}

class BusinessDetailTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var business: Business! {
        didSet {
            rowValues = []
            rowValues.append(business.address)
            rowValues.append(business.mail)
            rowValues.append("\(business.phone)")
            rowValues.append(business.website)
        }
    }
    var rowValues = [String]()
    let identifier = "identifier"
    let rowTitles = ["Address", "Mail", "Phone", "Website"]
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = rowTitles[indexPath.row]
        cell?.detailTextLabel?.text = rowValues[indexPath.row]
        return cell!
    }
}
