//
//  SavingManager.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol ISaveLoadManager {
    func getManager(by type: SavingManager) -> IDataManager
    func getUser() -> IUserDataModel?
}

class SaveLoadManager: ISaveLoadManager {
    let currentUser = CurrentUser.shared
    
    func getManager(by type: SavingManager) -> IDataManager {
        switch type {
        case .GDCSaving:
            return GCDDataManager()
        default:
            return OperationDataManager()
        }
    }
    
    func getUser() -> IUserDataModel? {
        let user = currentUser.getUser()
        return user
    }
}
