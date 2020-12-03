//
//  Message.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 18.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import Firebase

struct Message: IFirebaseDocumentInit {
    var content: String
    var created: Date
    var senderId: String
    var senderName: String
    
    init?(document: QueryDocumentSnapshot) {
        let item = document.data()
        if let content = item["content"] as? String,
               let senderName = item["senderName"] as? String,
               let senderId = item["senderId"] as? String,
               let created = item["created"] as? Timestamp {
            let date = created.dateValue()
            self.content = content
            self.created = date
            self.senderId = senderId
            self.senderName = senderName
        } else {
            return nil
        }
    }
}
