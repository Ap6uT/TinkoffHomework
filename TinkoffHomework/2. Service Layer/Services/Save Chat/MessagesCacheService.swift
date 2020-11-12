//
//  MessagesCacheService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

protocol IMessagesCacheService {
    func makeMessagesSave(channelID: String, messages: [Message])
}

struct MessagesCacheService: IMessagesCacheService {
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func makeMessagesSave(channelID: String, messages: [Message]) {
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
