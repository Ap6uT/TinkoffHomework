//
//  FetchedResultService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchedResultService {
    func getFetchedResultsController<Object: NSManagedObject>(request: NSFetchRequest<Object>) -> NSFetchedResultsController<Object>
}

class FetchedResultService: IFetchedResultService {
    let coreDataStack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getFetchedResultsController<Object: NSManagedObject>(request: NSFetchRequest<Object>) -> NSFetchedResultsController<Object> {
        let fetchedResultsController = NSFetchedResultsController<Object>(
            fetchRequest: request,
            managedObjectContext: coreDataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        return fetchedResultsController
    }
}
