//
//  DataManagerProtocol.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

enum SavingManager {
    case GDCSaving
    case OperationSaving
}

protocol IDataManager {
    func save(user: UserDataModel, complition: @escaping (Bool) -> Void)
    func load(complition: @escaping (UserDataModel) -> Void)
}
