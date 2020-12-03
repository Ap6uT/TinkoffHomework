//
//  ChannelsCacheService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

protocol IChannelsCacheService {
    func makeChannelsSave(channels: [Channel])
    func deleteChannel(_ channel: ChannelDB)
}

struct ChannelsCacheService: IChannelsCacheService {
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeChannelsSave(channels: [Channel]) {
        coreDataStack.performSave { context in
            channels.forEach { channel in
                _ = ChannelDB(channel: channel, in: context)
            }
        }
    }
    
    func deleteChannel(_ channel: ChannelDB) {
        let context = coreDataStack.mainContext
        context.delete(channel)
    }
}
