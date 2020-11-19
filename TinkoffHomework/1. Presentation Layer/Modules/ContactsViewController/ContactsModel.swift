//
//  ContactsModel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 10.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import CoreData

protocol IContactsModel: class {
    func applyTheme(_ theme: Theme)
    func getTheme() -> Theme
    
    func saveChannels(channels: [Channel])
    
    func observeCoreDataStack()
    func deleteChannel(_ channel: ChannelDB)
    func getFetchedResultsController() -> NSFetchedResultsController<ChannelDB>
    
    func getChannels(complition: @escaping () -> Void)
    func isChannelExist(channelId: String) -> Bool
    func addChannel(_ name: String)
    func removeChat(with id: String)
    
    var channels: [Channel] { get }
}

protocol IContactsModelDelegate: class {
    
}

class ContactsModel: IContactsModel {
    weak var delegate: IContactsModelDelegate?
    
    let themesService: IThemesService
    let chatSave: IChannelsCacheService
    let fetchedResult: IFetchedResultService
    let chatLoad: IChannelsLoadService
    let observe: IObserveCacheService
    
    var channels = [Channel]()
    
    init(themesService: IThemesService,
         chatSave: IChannelsCacheService,
         fetchedResult: IFetchedResultService,
         observe: IObserveCacheService,
         chatLoad: IChannelsLoadService) {
        self.themesService = themesService
        self.chatSave = chatSave
        self.fetchedResult = fetchedResult
        self.chatLoad = chatLoad
        self.observe = observe
    }
    
    func getChannels(complition: @escaping () -> Void) {
        channels = []
        chatLoad.getChannels(complition: { [weak self] channels in
            let sortedChannels = channels.sorted { (lhs: Channel, rhs: Channel) in
                switch (lhs.lastActivity, rhs.lastActivity) {
                case let(l?, r?): return l > r
                case (nil, _): return false
                case (_?, nil): return true
                }
            }
            self?.channels = sortedChannels
            DispatchQueue.main.async {
                complition()
            }
        })
    }
    
    func isChannelExist(channelId: String) -> Bool {
        for channel in channels where channel.identifier == channelId {
            //if channel.identifier == channelId {
            return true
            //}
        }
        return false
    }
    
    func addChannel(_ name: String) {
        chatLoad.addChannel(name)
    }
    
    func removeChat(with id: String) {
        chatLoad.removeChannel(by: id)
    }
    
    func applyTheme(_ theme: Theme) {
        themesService.applyTheme(theme)
    }
    
    func getTheme() -> Theme {
        return themesService.currentTheme()
    }
    
    func saveChannels(channels: [Channel]) {
        chatSave.makeChannelsSave(channels: channels)
    }
    
    func observeCoreDataStack() {
        observe.observeCoreDataStack()
    }
    
    func deleteChannel(_ channel: ChannelDB) {
        chatSave.deleteChannel(channel)
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController<ChannelDB> {
        let request = NSFetchRequest<ChannelDB>(entityName: "ChannelDB")
        request.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return fetchedResult.getFetchedResultsController(request: request)
    }
}
