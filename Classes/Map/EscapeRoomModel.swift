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

enum Difficulty: Int {
    case easy
    case medium
    case hard
}

struct Room {
    let documentId: String
    let name: String
    let businessId: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let duration: Int
    let city: String
    let categories: [String]
    let difficulty: Difficulty
    let maxPlayers: Int
    let image: String
    var ratingCount: Int
    var averageRating: Float
}

extension Room {
    init?(dictionary: [String : Any], documentId: String) {
        
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let businessId = dictionary["businessId"] as? String,
            let coordinate = dictionary["coordinate"] as? GeoPoint,
            let duration = dictionary["duration"] as? Int,
            let city = dictionary["city"] as? String,
            let categories = dictionary["categories"] as? [String],
            let difficulty = dictionary["difficulty"] as? Int,
            let maxPlayers = dictionary["maxPlayers"] as? Int,
            let diff = Difficulty(rawValue: difficulty),
            let image = dictionary["image"] as? String,
            let ratingCount = dictionary["ratingCount"] as? Int,
            let averageRating = dictionary["averageRating"] as? Float else { return nil }
        
        
        
        self.init(documentId: documentId, name: name, businessId: businessId, description: description, coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), duration: duration, city: city, categories: categories, difficulty: diff, maxPlayers: maxPlayers, image: image, ratingCount: ratingCount, averageRating: averageRating)
    }
}

struct DocumentIds {
    let business: String
    let room: String
}

struct Review {
    
    var rating: Int // Can also be enum
    var userId: String
    var roomId: String
    var documentId: String
    
    var dictionary: [String: Any] {
        return [
            "rating": rating,
            "userId": userId,
            "roomId": roomId
        ]
    }
    
}

extension Review {
    
    init?(dictionary: [String : Any], documentId: String) {
        guard let rating = dictionary["rating"] as? Int,
            let userId = dictionary["userId"] as? String,
            let roomId = dictionary["roomId"] as? String else { return nil }
        
        self.init(rating: rating, userId: userId, roomId: roomId, documentId: documentId)
    }
    
}

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}
