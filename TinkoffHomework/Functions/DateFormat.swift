//
//  DateFormat.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 30.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

func dateFormatter(date: Date,dateFormat:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
}
