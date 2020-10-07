//
//  ThemeManager.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 07.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

struct ThemeManager {
    static let SelectedThemeKey = "SelectedTheme"
    
    static func currentTheme() -> Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: SelectedThemeKey)
        return Theme(rawValue: storedTheme) ?? .classic
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)

        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        
        //UINavigationBar.appearance().backgroundColor = theme.barColor
        UILabel.appearance().textColor = theme.textColor
        UIButton.appearance().setTitleColor(theme.textColor, for: .normal)
        //UIView.appearance().backgroundColor = theme.backgroundColor
        UITableView.appearance().backgroundColor = theme.backgroundColor
        UITableView.appearance().tintColor = theme.secondaryColor
        UITableView.appearance().separatorColor = theme.secondaryColor
        
        //UIActionSheet.appearance().actionSheetStyle = theme.actionSheetStyle
        // что-то пошло не так и я не могу найти, где сменить его стиль
        
        
    }
}
