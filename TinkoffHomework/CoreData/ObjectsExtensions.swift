//
//  ObjectsExtensions.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 27.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

extension ChannelDB {
    convenience init(channel: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = channel.identifier
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
    }
    
    var about: String {
        let description = "\(String(describing: name))\n"
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageDB }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""
        
        return description + messages
    }
}

extension MessageDB {
    convenience init(message: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.content = message.content
        self.created = message.created
        self.senderId = message.senderId
        self.senderName = message.senderName
    }
    
    var about: String {
        return "message by \(String(describing: senderName)): \(String(describing: content)) \n"
    }
}
