//
//  UIViewController + Navigation.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 13.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func embed() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [self]
        return navigationController
    }
}
