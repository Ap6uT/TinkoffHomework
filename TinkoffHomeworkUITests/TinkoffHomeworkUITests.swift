//
//  TinkoffHomeworkUITests.swift
//  TinkoffHomeworkUITests
//
//  Created by Alexander Grishin on 03.12.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import XCTest

class TinkoffHomeworkUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let rightNavBarButton = app.navigationBars.buttons["navRightItem"]
        XCTAssert(rightNavBarButton.exists)
        rightNavBarButton.tap()
        
        // вот это строчка через запись была
        // остальные пришлось написать самому
        // какая-то сомнительная польза))
        app/*@START_MENU_TOKEN@*/.staticTexts["Edit"]/*[[".buttons[\"Edit\"].staticTexts[\"Edit\"]",".staticTexts[\"Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let nameTextField = app.textFields["nameTextField"]
        XCTAssert(nameTextField.exists)
        
        let descriprionTextView = app.textViews["descriprionTextView"]
        XCTAssert(descriprionTextView.exists)
    }
}
