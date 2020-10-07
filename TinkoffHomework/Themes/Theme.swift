//
//  Theme.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 07.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

enum Theme: Int {
    case classic = 1
    case day = 2
    case night = 3
    
    var mainColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor(red: 100.0/255.0, green: 101.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .night:
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    var actionSheetStyle: UIActionSheetStyle {
        switch self {
        case .classic, .day:
            return .default
        case .night:
            return .blackOpaque
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .classic, .day:
            return .default
        case .night:
            return .black
        }
    }
    
    
    var barColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
    }
    
    var myMessageColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 220.0/255.0, green: 247.0/255.0, blue: 197.0/255.0, alpha: 1.0)
        case .day:
            return UIColor(red: 67.0/255.0, green: 137.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 92.0/255.0, green: 92.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        }
    }
    
    var myMessageTextColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .night, .day:
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    var otherMessageColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        case .day:
            return UIColor(red: 234.0/255.0, green: 235.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 92.0/255.0, green: 92.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 6.0/255.0, green: 6.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .classic, .day:
            return UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        case .night:
            return UIColor(red: 27.0/255.0, green: 27.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
    
}
