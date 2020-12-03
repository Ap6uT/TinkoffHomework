//
//  SavingTests.swift
//  SavingTests
//
//  Created by Alexander Grishin on 01.12.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

@testable import TinkoffHomework
import XCTest

class SavingTests: XCTestCase {
    func testExample() throws {
        if let chat = ChatMock.shared() as? ChatMock {
            let chatName = "test chat"
            let channelsLoadServices = ChannelsLoadService(chat: chat)
            
            channelsLoadServices.addChannel(chatName)
            channelsLoadServices.removeChannel(by: chatName)
            channelsLoadServices.getChannels(complition: { _ in })
            
            XCTAssertEqual(chat.savingPath, chatName)
            XCTAssertEqual(chat.deletingPath, chatName)
        }
    }
}
