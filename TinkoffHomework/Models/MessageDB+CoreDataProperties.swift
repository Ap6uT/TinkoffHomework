//
//  MessageDB+CoreDataProperties.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 03.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

extension MessageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "MessageDB")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDB?
}
