//
//  FirebaseAPI.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 18.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import Firebase

protocol IChatAPI {
    static func shared() -> IChatAPI
    func getDocuments<Object: IFirebaseDocumentInit>(for path: String, complition: @escaping ([Object]) -> Void)
    func addDocument(for path: String, document: [String: Any])
    func removeDocument(in path: String, by id: String)
}

class ChatAPI: IChatAPI {
    private static let sharedSingleton = ChatAPI()
    let currentUser = CurrentUser.shared
    
    lazy var db = Firestore.firestore()
    //lazy var reference = db.collection("channels")
    
    private init() {
        
    }
    
    static func shared() -> IChatAPI {
        return sharedSingleton
    }
    
    func getDocuments<Object: IFirebaseDocumentInit>(for path: String, complition: @escaping ([Object]) -> Void) {
        let reference = db.collection(path)
        reference.addSnapshotListener { snapshot, _ in
            var objects = [Object]()
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if let object = Object(document: document) {
                        objects.append(object)
                    }
                }
            }
            complition(objects)
        }
    }
    
    func addDocument(for path: String, document: [String: Any]) {
        let reference = db.collection(path)
        reference.addDocument(data: document)
    }
    
    func removeDocument(in path: String, by id: String) {
        let reference = db.collection(path)
        reference.document(id).delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("File deleted successfully")
            }
            
        }
    }
}
