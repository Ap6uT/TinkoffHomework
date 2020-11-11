//
//  GCDDataManager.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class GCDDataManager: DataManagerProtocol {
    
    func save(user: UserDataModel, complition: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "save data", attributes: .concurrent)
        
        var imageSavingSuccess = true
        var nameSavingSuccess = true
        var descriptionSavingSuccess = true
        
        if let image = user.avatar {
            group.enter()
            queue.async {
                imageSavingSuccess = SaveLoadData.saveFile(data: image, fileName: .avatar)
                group.leave()
            }
        }
        
        if let name = user.name {
            group.enter()
            queue.async {
                nameSavingSuccess = SaveLoadData.saveFile(data: name, fileName: .name)
                group.leave()
            }
        }
        
        if let description = user.description {
            group.enter()
            queue.async {
                descriptionSavingSuccess = SaveLoadData.saveFile(data: description, fileName: .description)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let success = imageSavingSuccess && nameSavingSuccess && descriptionSavingSuccess
            complition(success)
        }
    }
    
    func load(complition: @escaping (UserDataModel) -> Void) {
        var user = UserDataModel()
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "load data", attributes: .concurrent)
        
        group.enter()
        queue.async {
            if let dataImage = SaveLoadData.loadFile(fileName: .avatar), let image = UIImage(data: dataImage) {
                user.avatar = image
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let dataName = SaveLoadData.loadFile(fileName: .name), let name = String(data: dataName, encoding: .utf8) {
                user.name = name
            }
            group.leave()
        }
        
        group.enter()
        queue.async {
            if let dataDescription = SaveLoadData.loadFile(fileName: .description), let description = String(data: dataDescription, encoding: .utf8) {
                user.description = description
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            complition(user)
        }
        
    }

}
