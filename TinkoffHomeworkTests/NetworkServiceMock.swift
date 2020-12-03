//
//  NetworkServiceMock.swift
//  TinkoffHomeworkTests
//
//  Created by Alexander Grishin on 29.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

@testable import TinkoffHomework
import Foundation

final class RestMock: IRest {
    var callsCount = 0
    var askedPage = ""
    var errorStub: ((FailureHandler?) -> Void)?
    var loadStub: ((SuccessHandler<Codable>?) -> Void)?
    
    static func shared() -> IRest {
        return RestMock()
    }
    
    func request<T>(_ endpoint: String, method: HTTPMethod, parameters: Parameters, success: SuccessHandler<T>?, failure: FailureHandler?) where T: Decodable, T: Encodable {
        callsCount += 1
        askedPage = parameters["page"] as? String ?? ""
        loadStub?(success as? SuccessHandler<Codable>)
        errorStub?(failure)
    }
}
