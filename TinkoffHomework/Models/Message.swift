//
//  Message.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 18.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import Firebase

struct Message: Codable {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}
