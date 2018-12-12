//
//  CompletedRoom.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 01/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//
import FirebaseFirestore

struct CompletedRoom {
    let userId: String
    let roomId: String
    let date: Date
    
    func documentData() -> [String:Any] {
        return ["userId": userId,
                "roomId": roomId,
                "timestamp": date]
    }
}

extension CompletedRoom {
    init?(dictionary: [String : Any]) {
        guard let userId = dictionary["userId"] as? String,
            let roomId = dictionary["roomId"] as? String,
        let timestamp = dictionary["timestamp"] as? Timestamp else { return nil}
        
        self.init(userId: userId, roomId: roomId, date: timestamp.dateValue())
    }
}
