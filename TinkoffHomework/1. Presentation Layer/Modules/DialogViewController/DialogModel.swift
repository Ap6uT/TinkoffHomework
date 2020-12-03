//
//  DialogModel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 10.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

protocol IDialogModel: class {
    func getTheme() -> Theme
    func saveDialog(channelID: String, messages: [Message])
    func getFetchedResultsController(channelId: String) -> NSFetchedResultsController<MessageDB>
    
    func getMessages(for channelId: String, complition: @escaping () -> Void)
    func addMessage(_ message: String, forChannel channelId: String)
    func getUserId() -> String?
    var messages: [Message] { get }
}

protocol IDialogModelDelegate: class {
    
}

class DialogModel: IDialogModel {
    weak var delegate: IDialogModelDelegate?
    
    let themesService: IThemesService
    let chatSave: IMessagesCacheService
    let chatLoad: IMessagesLoadService
    let fetchedResult: IFetchedResultService
    
    var messages = [Message]()
    
    init(themesService: IThemesService,
         chatSave: IMessagesCacheService,
         fetchedResult: IFetchedResultService,
         chatLoad: IMessagesLoadService) {
        self.themesService = themesService
        self.chatSave = chatSave
        self.fetchedResult = fetchedResult
        self.chatLoad = chatLoad
    }
    
    func getTheme() -> Theme {
        return themesService.currentTheme()
    }
    
    func getMessages(for channelId: String, complition: @escaping () -> Void) {
        messages = []
        chatLoad.getMessages(for: channelId, complition: { [weak self] messages in
            let sortedMessages = messages.sorted { (lhs: Message, rhs: Message) in
                return lhs.created < rhs.created
            }
            self?.messages = sortedMessages
            DispatchQueue.main.async {
                complition()
            }
        })
    }
    
    func addMessage(_ message: String, forChannel channelId: String) {
        chatLoad.addMessage(message, forChannel: channelId)
    }
    
    func getUserId() -> String? {
        return chatLoad.getUserId()
    }
    
    func saveDialog(channelID: String, messages: [Message]) {
        chatSave.makeMessagesSave(channelID: channelID, messages: messages)
    }
    
    func getFetchedResultsController(channelId: String) -> NSFetchedResultsController<MessageDB> {
        let request = NSFetchRequest<MessageDB>(entityName: "MessageDB")

        request.predicate = NSPredicate(format: "channel.identifier == %@", channelId)
        request.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return fetchedResult.getFetchedResultsController(request: request)
    }
}
