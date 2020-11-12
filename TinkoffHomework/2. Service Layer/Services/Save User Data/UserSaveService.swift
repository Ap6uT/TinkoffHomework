//
//  UserSaveService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 11.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol IUserSaveService {
    func saveUserData(by savingManagerType: SavingManager, user: UserDataModel, complition: @escaping (Bool) -> Void)
    func loadUserData() -> IUserDataModel?
}

class UserSaveService: IUserSaveService {
    let manager: ISaveLoadManager
    
    init(manager: ISaveLoadManager) {
        self.manager = manager
    }
    
    func saveUserData(by savingManagerType: SavingManager, user: UserDataModel, complition: @escaping (Bool) -> Void) {
        let savingManager = manager.getManager(by: savingManagerType)
        savingManager.save(user: user, complition: complition)
    }
    
    func loadUserData() -> IUserDataModel? {
        return manager.getUser()
    }
}
