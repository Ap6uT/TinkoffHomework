//
//  Rest.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 15.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", delete = "DELETE"
}

typealias SuccessHandler<T> = (_ data: T) -> Void

typealias FailureHandler = (_ error: Error) -> Void

protocol IRest {
    static func shared() -> IRest
    func request <T: Codable>(_ endpoint: String,
                              method: HTTPMethod,
                              parameters: Parameters,
                              success: SuccessHandler<T>?,
                              failure: FailureHandler?)
}

class Rest: IRest {
    private static let sharedSingleton = Rest()

    private init() {
    }
    
    private let urlSession = URLSession(configuration: .default)
    
    private enum API {
         static let baseURL = "https://pixabay.com/api/"
     }
    
    static func shared() -> IRest {
        return sharedSingleton
    }
    
    func request <T: Codable>(_ endpoint: String,
                              method: HTTPMethod = .get,
                              parameters: Parameters = [:],
                              success: SuccessHandler<T>?,
                              failure: FailureHandler?) {

        let urlRequest = buildURLRequest(endpoint, method: method, parameters: parameters)

        urlSession.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                //print(NSString(data: data, encoding:String.Encoding.utf8.rawValue)!)
                DispatchQueue.global(qos: .utility).async {
                    do {
                        let object: T = try self.getType(from: data)
                        DispatchQueue.main.async {
                            success?(object)
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            print("******* error message")
                            failure?(error)
                        }
                    }
                }
            } else if let error = error {
                failure?(error)
            }
        }.resume()
        
    }
    
    private func getType<T: Codable>(from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func buildURLRequest(_ endpoint: String, method: HTTPMethod, parameters: Parameters) -> URLRequest {
        let url = URL(string: API.baseURL + endpoint)!.appendingQueryParameters([/*"format": "json", */"key": tokenRestAPI])

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        switch method {
        case .get, .delete:
            urlRequest.url?.appendQueryParameters(parameters)
        case .post:
            urlRequest.httpBody = Data(parameters: parameters)
        }
        return urlRequest
    }
}

extension Data {
    init(parameters: Parameters) {
        self = parameters.map { "\($0.key)=\($0.value)&" }.joined().data(using: .utf8)!
    }
}
