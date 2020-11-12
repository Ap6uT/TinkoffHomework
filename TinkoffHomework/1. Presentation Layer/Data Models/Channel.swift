//
//  Channel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 18.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import Firebase

protocol IFirebaseDocumentInit {
    init?(document: QueryDocumentSnapshot)
}

struct Channel: IFirebaseDocumentInit {
    var identifier: String
    var name: String
    var lastMessage: String?
    var lastActivity: Date?
    
    init?(document: QueryDocumentSnapshot) {
        let item = document.data()
        let id = document.documentID
        if let name = item["name"] as? String {
            var date: Date?
            let lastMessage: String? = item["lastMessage"] as? String
            if let lastActivity = item["lastActivity"] as? Timestamp {
                date = lastActivity.dateValue()
            }
            self.identifier = id
            self.name = name
            self.lastMessage = lastMessage
            self.lastActivity = date
        } else {
            return nil
        }
    }
}
