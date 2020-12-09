//
//  TinkoffHomeworkTests.swift
//  TinkoffHomeworkTests
//
//  Created by Alexander Grishin on 29.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

@testable import TinkoffHomework
import XCTest

class TinkoffHomeworkTests: XCTestCase {

    func testExample() throws {
        // Arrange
        if let rest = RestMock.shared() as? RestMock {
            let networkService = NetworkService(rest: rest)
            let gallery = RestGallery(webformatURL: "")
            rest.loadStub = { complition in
                complition?([gallery])
            }
            let page = 1
            // Act
            networkService.getImages(forPage: page, success: { _ in }, failure: { _ in })
            
            // Assert
            XCTAssertEqual(rest.callsCount, 1)
            XCTAssertEqual(rest.askedPage, "\(page)")
        }
    }
}
