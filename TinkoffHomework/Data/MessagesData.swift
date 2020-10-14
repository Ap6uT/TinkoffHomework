//
//  MessagesData.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 07.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

class MessagesData {
    
    public static let shared = MessagesData()
    

    
    private init() {
        
    }
    
    func getContacts() -> [ConversationCellModel] {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let otherDate = formatter.date(from: "2020/09/29 00:00") ?? Date()
        
        let contacts = [
            ConversationCellModel(name: "Kratos", message: "BOI", date: otherDate, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Gordon Freeman", message: "", date: date, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Adam Jensen", message: "I Never Asked For This", date: date, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Space Module", message: "SPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACE", date: date, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Hodor", message: "Hodor", date: otherDate, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "GLaDOS", message: "I'm a Potato", date: otherDate, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Cole Phelps", message: "Doubt", date: date, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Morgan Yu", message: "", date: otherDate, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Geralt", message: "hmmm", date: date, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Connor RK800", message: "I'm sure we used to be friends before I was reset", date: otherDate, isOnline: true, hasUnreadMessage: true),
            
            ConversationCellModel(name: "Chell", message: "", date: date, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "DoomGuy", message: "", date: otherDate, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "The Weighted Companion Cube", message: "why?", date: otherDate, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Big Smoke", message: "All we had to do was follow the damn train CJ!", date: date, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Toad", message: "Thank You Mario, But Our Princess is in Another Castle", date: otherDate, isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "G-Man", message: "Rise and shine", date: date, isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "Andrew Ryan", message: "A man chooses...a slave obeys", date: otherDate, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Commander Shepard", message: "I’m Commander Shepard, and this is my favorite store on the Citadel!", date: date, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Vaas", message: "Did I ever tell you the definition of insanity?", date: otherDate, isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "Cave Johnson", message: "Science isn’t about why! It’s about why not!", date: date, isOnline: false, hasUnreadMessage: true),
        ]
        return contacts
    }
    
    
    // тут кривые типы данных на выходе функции, лучше параметр добавить в структуру
    // все будет, но потом)))
    func getMessages() -> [(isMy: Bool, value: MessageCellModel)] {
        let messages = [
            (true, MessageCellModel(text: "Hi)")),
            (true, MessageCellModel(text: "did you like that message app?")),
            (false, MessageCellModel(text: "Hi")),
            (false, MessageCellModel(text: "not really")),
            (false, MessageCellModel(text: "you can do it much better")),
            (false, MessageCellModel(text: "look at this design")),
            (true, MessageCellModel(text: "ok")),
            (true, MessageCellModel(text: "i'll work on it")),
            (false, MessageCellModel(text: "you must")),
            (true, MessageCellModel(text: "it will be much better, you will see")),
        ]
        return messages
    }
}
