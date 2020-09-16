//
//  Log.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 15.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

let logEnabled = true

func printLog(_ object: Any) {
    if logEnabled {
        print(object)
    }
}
