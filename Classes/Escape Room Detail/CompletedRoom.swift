//
//  CompletedRoom.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 01/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

struct CompletedRoom {
    let userId: String
    let roomId: String
    
    func documentData() -> [String:Any] {
        return ["userId": userId, "roomId": roomId]
    }
}

extension CompletedRoom {
    init?(dictionary: [String : Any]) {
        guard let userId = dictionary["userId"] as? String,
            let roomId = dictionary["roomId"] as? String else { return nil}
        self.init(userId: userId, roomId: roomId)
    }
}
