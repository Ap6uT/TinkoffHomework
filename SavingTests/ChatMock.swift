//
//  SavingManagerMock.swift
//  SavingTests
//
//  Created by Alexander Grishin on 01.12.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

@testable import TinkoffHomework
import Foundation

final class ChatMock: IChatAPI {
    var savingPath = ""
    var deletingPath = ""
    //var getStub: (((([IFirebaseDocumentInit]) -> Void)?) -> Void)?
    
    static func shared() -> IChatAPI {
        return ChatMock()
    }

    // тут нужен typealias на замыкание
    func getDocuments<Object>(for path: String, complition: @escaping ([Object]) -> Void) where Object: IFirebaseDocumentInit {
        
    }
    
    func addDocument(for path: String, document: [String: Any]) {
        savingPath = (document["name"] as? String) ?? ""
    }
    
    func removeDocument(in path: String, by id: String) {
        deletingPath = id
    }
}
