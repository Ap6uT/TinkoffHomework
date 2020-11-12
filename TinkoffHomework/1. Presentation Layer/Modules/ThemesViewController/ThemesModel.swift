//
//  ThemesModel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 10.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol IThemesModel: class {
    var delegate: IThemesModelDelegate? { get set }
    func saveTheme(_ theme: Theme)
    func getTheme() -> Theme
}

protocol IThemesModelDelegate: class {
    
}

class ThemesModel: IThemesModel {
    weak var delegate: IThemesModelDelegate?
    
    let themesService: IThemesService
    
    init(themesService: IThemesService) {
        self.themesService = themesService
    }
    
    func saveTheme(_ theme: Theme) {
        themesService.saveTheme(theme)
    }
    
    func getTheme() -> Theme {
        return themesService.currentTheme()
    }
}
