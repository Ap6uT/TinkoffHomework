//
//  NetworkService.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 16.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

protocol INetworkService {
    func getImages(forPage page: Int, success: SuccessHandler<RestResponse>?, failure: FailureHandler?)
}

class NetworkService: INetworkService {
    let rest: IRest
    
    init(rest: IRest) {
        self.rest = rest
    }
    
    func getImages(forPage page: Int, success: SuccessHandler<RestResponse>?, failure: FailureHandler?) {
        rest.request("", method: .get, parameters: ["page": "\(page)", "per_page": 200], success: success, failure: failure)
    }
}
