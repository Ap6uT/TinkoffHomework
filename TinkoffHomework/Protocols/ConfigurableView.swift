//
//  ConfigurableView.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 29.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
