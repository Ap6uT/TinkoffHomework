//
//  ServicesAssembly.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 10.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var themesService: IThemesService { get }
    
    var channelsCacheService: IChannelsCacheService { get }
    var messagesCacheService: IMessagesCacheService { get }
    var observeCacheService: IObserveCacheService { get }
    var fetchedResultService: IFetchedResultService { get }
    
    var channelsLoad: IChannelsLoadService { get }
    var messagesLoad: IMessagesLoadService { get }
    
    var userSaveService: IUserSaveService { get }
    
    var networkService: INetworkService { get }
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelsCacheService: IChannelsCacheService = ChannelsCacheService(coreDataStack: coreAssembly.coreDataStack)
    lazy var messagesCacheService: IMessagesCacheService = MessagesCacheService(coreDataStack: coreAssembly.coreDataStack)
    lazy var observeCacheService: IObserveCacheService = ObserveCacheService(coreDataStack: coreAssembly.coreDataStack)
    lazy var fetchedResultService: IFetchedResultService = FetchedResultService(coreDataStack: coreAssembly.coreDataStack)

    lazy var themesService: IThemesService = ThemesService()
    
    lazy var channelsLoad: IChannelsLoadService = ChannelsLoadService(chat: coreAssembly.chat)
    lazy var messagesLoad: IMessagesLoadService = MessagesLoadService(
        chat: coreAssembly.chat,
        userLoader: coreAssembly.saveLoadManager)
    
    lazy var userSaveService: IUserSaveService = UserSaveService(manager: coreAssembly.saveLoadManager)
    
    lazy var networkService: INetworkService = NetworkService(rest: coreAssembly.rest)
    
}
