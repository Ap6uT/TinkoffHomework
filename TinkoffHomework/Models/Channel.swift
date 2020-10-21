//
//  Channel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 18.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

struct Channel: Codable {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
