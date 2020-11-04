//
//  FirebaseAPI.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 18.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import Firebase

class ChatAPI {
    public static let shared = ChatAPI()
    let currentUser = CurrentUser.shared
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    var channels = [Channel]()
    var messages = [Message]()
    
    private init() {
        
    }
    
    func addChannel(_ name: String) {
        let document: [String: Any] = ["name": name]
        reference.addDocument(data: document)
    }
    
    func getChannels(complition: @escaping () -> Void) {
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let snapshot = snapshot {
                var channels = [Channel]()
                for document in snapshot.documents {
                    let item = document.data()
                    let id = document.documentID
                    if let name = item["name"] as? String {
                        var date: Date?
                        let lastMessage: String? = item["lastMessage"] as? String
                        if let lastActivity = item["lastActivity"] as? Timestamp {
                            date = lastActivity.dateValue()
                        }
                        let channel = Channel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: date)
                        channels.append(channel)
                    }
                    
                }
                self?.channels = channels.sorted { (lhs: Channel, rhs: Channel) in
                    switch (lhs.lastActivity, rhs.lastActivity) {
                    case let(l?, r?): return l > r
                    case (nil, _): return false
                    case (_?, nil): return true
                    }
                }
                DispatchQueue.main.async {
                    complition()
                }
            }
        }
    }
    
    func removeChat(with channelId: String) {
        reference.document(channelId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("File deleted successfully")
            }
            
        }
    }
    
    func getChat(for channelId: String, complition: @escaping () -> Void) {
        let reference = db.collection("channels/\(channelId)/messages")
        reference.addSnapshotListener { [weak self] snapshot, _ in
            if let snapshot = snapshot {
                var messages = [Message]()
                for document in snapshot.documents {
                    let item = document.data()
                    if let content = item["content"] as? String,
                           let senderName = item["senderName"] as? String,
                           let senderId = item["senderId"] as? String,
                           let created = item["created"] as? Timestamp {
                        let date = created.dateValue()
                        let message = Message(content: content, created: date, senderId: senderId, senderName: senderName)
                        messages.append(message)
                    }
                }
                self?.messages = messages.sorted { (lhs: Message, rhs: Message) in
                    return lhs.created < rhs.created
                }
                DispatchQueue.main.async {
                    
                    complition()
                }
            }
            
        }
    }
    
    func addMessage(_ message: String, forChannel channelId: String) {
        let reference = db.collection("channels/\(channelId)/messages")
        let date = Timestamp(date: Date())
        let senderName: String
        if let user = currentUser.getUser() {
            senderName = user.name ?? "anonymous"
        } else {
            senderName = "anonymous"
        }
        
        if let senderId = getUserId() {
            let document: [String: Any] = ["content": message, "created": date, "senderId": senderId, "senderName": senderName]
            reference.addDocument(data: document)
        }
    }
    
    func getUserId() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    func isChannelExist(channelId: String) -> Bool {
        for channel in channels {
            if channel.identifier == channelId {
                return true
            }
        }
        return false
    }
    
}
