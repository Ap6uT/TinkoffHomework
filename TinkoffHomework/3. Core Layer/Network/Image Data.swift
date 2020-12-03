//
//  Image Data.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 15.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

struct RestResponse: Codable {
    var hits: [RestGallery]?
}

struct RestGallery: Codable {
    var webformatURL: String?
}
