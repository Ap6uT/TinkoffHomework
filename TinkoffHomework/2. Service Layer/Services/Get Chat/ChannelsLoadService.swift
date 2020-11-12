//
//  ChatLoadService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 11.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol IChannelsLoadService {
    func getChannels(complition: @escaping ([Channel]) -> Void)
    func removeChannel(by id: String)
    func addChannel(_ name: String)
}

class ChannelsLoadService: IChannelsLoadService {
    let chat: IChatAPI
    
    init(chat: IChatAPI) {
        self.chat = chat
    }
    
    func getChannels(complition: @escaping ([Channel]) -> Void) {
        let url = "channels"
        chat.getDocuments(for: url, complition: { channels in
            complition(channels)
        })
    }
    
    func removeChannel(by id: String) {
        let url = "channels"
        chat.removeDocument(in: url, by: id)
    }
    
    func addChannel(_ name: String) {
        let document: [String: Any] = ["name": name]
        let url = "channels"
        chat.addDocument(for: url, document: document)
    }
}
