//
//  GalleryModel.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 16.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol IGalleryModel: class {
    var gallery: [RestGallery] { get }
    func getImages(for page: Int, complition: @escaping () -> Void)
}

class GalleryModel: IGalleryModel {
    var gallery = [RestGallery]()
    
    let networkService: INetworkService
    
    init(networkService: INetworkService) {
        self.networkService = networkService
    }
    
    func getImages(for page: Int, complition: @escaping () -> Void) {
        networkService.getImages(forPage: page, success: { [weak self] response in
            self?.gallery = response.hits ?? []
            complition()
        }, failure: { error in
            print(error)
            complition()
        })
    }
}
