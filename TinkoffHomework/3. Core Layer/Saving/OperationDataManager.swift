//
//  OperationDataManager.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class OperationDataManager: IDataManager {
    
    func save(user: UserDataModel, complition: @escaping (Bool) -> Void) {
        
        var imageSavingSuccess = true
        var nameSavingSuccess = true
        var descriptionSavingSuccess = true
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        if let image = user.avatar {
            let operation = OperationSaving(data: image, fileName: .avatar)
            operation.completionBlock = {
                if operation.isCancelled {
                    return
                }
                imageSavingSuccess = true
            }
            queue.addOperation(operation)
        }
        
        if let name = user.name {
            let operation = OperationSaving(data: name, fileName: .name)
            operation.completionBlock = {
                if operation.isCancelled {
                    return
                }
                nameSavingSuccess = true
            }
            queue.addOperation(operation)
        }
        
        if let description = user.description {
            let operation = OperationSaving(data: description, fileName: .description)
            operation.completionBlock = {
                if operation.isCancelled {
                    return
                }
                descriptionSavingSuccess = true
            }
            queue.addOperation(operation)
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        let success = imageSavingSuccess && nameSavingSuccess && descriptionSavingSuccess
        complition(success)
        
    }
    
    func load(complition: @escaping (UserDataModel) -> Void) {
        let queue = OperationQueue()
        
        var user = UserDataModel()
        
        let operationAvatar = OperationLoading(fileName: .avatar)
        operationAvatar.completionBlock = {
            if operationAvatar.isCancelled {
                return
            }
            if let dataImage = operationAvatar.data, let image = UIImage(data: dataImage) {
                user.avatar = image
            }
        }
        
        let operationName = OperationLoading(fileName: .name)
        operationName.completionBlock = {
            if operationName.isCancelled {
                return
            }
            if let dataName = operationName.data, let name = String(data: dataName, encoding: .utf8) {
                user.name = name
            }
        }
        
        let operationDescription = OperationLoading(fileName: .description)
        operationDescription.completionBlock = {
            if operationDescription.isCancelled {
                return
            }
            if let dataDescription = operationDescription.data, let description = String(data: dataDescription, encoding: .utf8) {
                user.description = description
            }
        }

        queue.addOperations([operationAvatar, operationName, operationDescription], waitUntilFinished: true)
        
        complition(user)
        
    }
}
