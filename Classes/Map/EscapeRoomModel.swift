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
}

extension Business {
    init?(dictionary: [String : Any]) {
        
        guard let name = dictionary["name"] as? String,
            let address = dictionary["address"] as? String,
            let mail = dictionary["mail"] as? String,
            let phone = dictionary["phone"] as? Int,
            let website = dictionary["website"] as? String else { return nil }
        
        self.init(name: name, address: address, mail: mail, website: website, phone: phone)
    }
}

struct Room {
    let name: String
    let businessId: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let duration: Int
}

extension Room {
    init?(dictionary: [String : Any]) {
        
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let businessId = dictionary["businessId"] as? String,
            let coordinate = dictionary["coordinate"] as? GeoPoint,
            let duration = dictionary["duration"] as? Int else { return nil }
        
        self.init(name: name, businessId: businessId, description: description, coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), duration: duration)
    }
}



