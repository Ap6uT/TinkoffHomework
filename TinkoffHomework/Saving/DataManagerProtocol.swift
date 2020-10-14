//
//  DataManagerProtocol.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation


protocol DataManagerProtocol {
    func save(user: UserDataModel, complition: @escaping (Bool) -> ())
    func load(complition: @escaping (UserDataModel) -> ())
}
