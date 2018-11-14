//
//  EscapeRoomModel.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 14/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//
import Firebase
import MapKit

struct Business {
    let name: String
    let address: String
    let mail: String
    let website: String
    let phone: Int
    
    init(json: [String:Any]) {
        name = json["name"] as! String
        address = json["address"] as! String
        mail = json["mail"] as! String
        phone = json["phone"] as! Int
        website = json["website"] as! String
    }
}


class FirebaseManager {
    
    static func getBusinesses(completionHandler: @escaping([Business]) -> Void ) {
        var businesses: [Business] = []
        let ref = Database.database().reference(withPath: "business")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let snapshotValue = snapshot.children.allObjects as! [DataSnapshot]
            snapshotValue.forEach({
                let snap = $0.value as! [String:Any]
                let business = Business(json: snap)
                businesses.append(business)
            })
            completionHandler(businesses)
        })
    }
    
    static func getBusiness(withName name: String, completionHandler: @escaping(Business) -> Void ) {
        let ref = Database.database().reference(withPath: "business").queryOrdered(byChild: "name").queryEqual(toValue: name)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let snap = snapshot.children.allObjects.first as! DataSnapshot
            let business = Business(json: snap.value as! [String:Any])
            completionHandler(business)
        })
    }
}



