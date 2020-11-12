//
//  MessagesLoadService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 11.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol IMessagesLoadService {
    func getMessages(for channelId: String, complition: @escaping ([Message]) -> Void)
    func addMessage(_ message: String, forChannel channelId: String)
    func getUserId() -> String?
}

class MessagesLoadService: IMessagesLoadService {
    let chat: IChatAPI
    let userLoader: ISaveLoadManager
    
    init(chat: IChatAPI, userLoader: ISaveLoadManager) {
        self.chat = chat
        self.userLoader = userLoader
    }
    
    func getMessages(for channelId: String, complition: @escaping ([Message]) -> Void) {
        let url = "channels/\(channelId)/messages"
        chat.getDocuments(for: url, complition: { messages in
            complition(messages)
        })
    }
    
    func addMessage(_ message: String, forChannel channelId: String) {
        let path = "channels/\(channelId)/messages"
        let date = Timestamp(date: Date())
        let senderName: String
        if let user = userLoader.getUser() {
            senderName = user.name ?? "anonymous"
        } else {
            senderName = "anonymous"
        }
        
        if let senderId = getUserId() {
            let document: [String: Any] = ["content": message, "created": date, "senderId": senderId, "senderName": senderName]
            chat.addDocument(for: path, document: document)
        }
    }
    
    func getUserId() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
