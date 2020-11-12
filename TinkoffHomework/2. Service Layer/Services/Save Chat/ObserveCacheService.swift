//
//  ObserveCacheService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

protocol IObserveCacheService {
    func observeCoreDataStack()
}

struct ObserveCacheService: IObserveCacheService {
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func observeCoreDataStack() {
        coreDataStack.enableObservers()
    }
}
