//
//  ChatRequest.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 27.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

struct ChatRequest {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeChannelsRequest(channels: [Channel]) {
        coreDataStack.performSave { context in
            channels.forEach { channel in
                _ = ChannelDB(channel: channel, in: context)
            }
        }
    }
    
    func makeMessagesRequest(channelID: String, messages: [Message]) {
        coreDataStack.performSave { context in
            let request: NSFetchRequest<ChannelDB> = ChannelDB.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "identifier = %@", channelID)
            do {
                if let channel_db = try context.fetch(request).first {
                    messages.forEach { message in
                        let message_db = MessageDB(message: message, in: context)
                        channel_db.addToMessages(message_db)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}
