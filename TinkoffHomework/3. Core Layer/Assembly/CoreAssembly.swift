//
//  CoreAssembly.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 10.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: ICoreDataStack { get }
    var chat: IChatAPI { get }
    var saveLoadManager: ISaveLoadManager { get }
}

class CoreAssembly: ICoreAssembly {
    var coreDataStack = CoreDataStack.shared()
    var chat = ChatAPI.shared()
    var saveLoadManager: ISaveLoadManager = SaveLoadManager()
}
