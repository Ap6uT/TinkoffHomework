//
//  ChatRequest.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 27.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

struct ChatRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeChannelsRequest(channels: [Channel]) {
        coreDataStack.performSave { context in
            channels.forEach { channel in
                _ = Channel_db(channel: channel, in: context)
            }
        }
    }
    
    func makeMessagesRequest(channel: Channel, messages: [Message]) {
        coreDataStack.performSave { context in
            let channel_db = Channel_db(channel: channel, in: context)
            messages.forEach { message in
                let message_db = Message_db(message: message, in: context)
                channel_db.addToMessages(message_db)
            }
        }
    }
}
