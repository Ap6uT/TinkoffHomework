//
//  UserDataModel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

protocol IUserDataModel {
    var avatar: UIImage? { get set }
    var name: String? { get set }
    var description: String? { get set }
}

struct UserDataModel: IUserDataModel {
    var avatar: UIImage?
    var name: String?
    var description: String?
}
