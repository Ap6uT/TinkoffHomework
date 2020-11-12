//
//  ProfileModel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 10.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol IProfileModel: class {
    func getTheme() -> Theme
}

protocol IProfileModelDelegate: class {
    
}

class ProfileModel: IProfileModel {
    weak var delegate: IProfileModelDelegate?
    
    let saveUser: IUserSaveService
    let themesService: IThemesService
    
    init(themesService: IThemesService, saveUser: IUserSaveService) {
        self.themesService = themesService
        self.saveUser = saveUser
    }
    
    func getTheme() -> Theme {
        return themesService.currentTheme()
    }
}
