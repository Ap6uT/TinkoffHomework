//
//  CurrentUser.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 21.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

class CurrentUser {
    private var user: UserDataModel?
    
    public static let shared = CurrentUser()
    
    private init() {
        let operationManager = GCDDataManager()
        operationManager.load(complition: { [weak self] user in
            self?.user = user
        })
    }
    
    func getUser() -> UserDataModel? {
        return user
    }
}
