//
//  BthereUITests.swift
//  BthereUITests
//
//  Created by BThere on 11/29/18.
//  Copyright © 2018 Webit. All rights reserved.
//

import XCTest

class BthereUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let app = XCUIApplication()
     //   app.buttons["Already a member? Log in"].tap()

        let window = app.children(matching: .window).element(boundBy: 0)
//        let element4 = window.children(matching: .other).element(boundBy: 1).children(matching: .other).element
//        let textField = element4.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .textField).element
//        textField.tap()
//        textField.tap()
//        textField/*@START_MENU_TOKEN@*/.press(forDuration: 1.0);/*[[".tap()",".press(forDuration: 1.0);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        textField/*@START_MENU_TOKEN@*/.press(forDuration: 1.1);/*[[".tap()",".press(forDuration: 1.1);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        textField.tap()
//        textField/*@START_MENU_TOKEN@*/.press(forDuration: 1.2);/*[[".tap()",".press(forDuration: 1.2);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        textField.swipeUp()
//
//        let key = app/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key.tap()
//
//        let key2 = app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key2.tap()
//        key2.tap()
//
//        let key3 = app/*@START_MENU_TOKEN@*/.keys["8"]/*[[".keyboards.keys[\"8\"]",".keys[\"8\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key3.tap()
//
//        let key4 = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key4.tap()
//        key3.tap()
//        key4.tap()
//        key3.tap()
//        key4.tap()
//        key3.tap()
//        key4.tap()
//        key3.tap()
//        window.children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 0).tap()
//
//        let okButton = app.alerts.buttons["Ok"]
//        okButton.tap()
//
//        let connectButton = app.buttons["Connect"]
//        connectButton.tap()
//        textField.tap()
//        key.tap()
//        key2.tap()
//        key2.tap()
//        key2.tap()
//
//        let key5 = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key5.tap()
//        key5.tap()
//        key4.tap()
//
//        let key6 = app/*@START_MENU_TOKEN@*/.keys["6"]/*[[".keyboards.keys[\"6\"]",".keys[\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key6.tap()
//        key6.tap()
//        key2.tap()
//        key6.tap()
//        key2.tap()
//        key6.tap()
//        connectButton.tap()
//        element4.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .textField).element.tap()
//        key5.tap()
//        key5.tap()
//        key5.tap()
//        key5.tap()
//        key5.tap()
//        app.buttons["Continue"].tap()
//
//        let element5 = window.children(matching: .other).element.children(matching: .other).element
//        let element = element5.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
//        element.children(matching: .other).element(boundBy: 2).tap()
//        element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 4).tap()
//
//        let element3 = element5.children(matching: .other).element(boundBy: 1)
//        let element2 = element3.children(matching: .other).element(boundBy: 3).children(matching: .other).element.children(matching: .other).element
//        element2.tap()
//        app.datePickers.pickerWheels["29"].tap()
//        element2.tap()
//        app.otherElements["AssistiveTouch menu"].swipeDown()
//        element3.children(matching: .other).element(boundBy: 5).children(matching: .other).element.children(matching: .other).element.tap()
//        element3.children(matching: .other).element(boundBy: 4).tap()
//        app.buttons["OK strock black"].tap()
//        app.buttons["Block"].tap()
//        okButton.tap()
//        app.buttons["21"].tap()
//   app.navigationBars["Diaries Model"].staticTexts["Suhddjrj"].tap()

        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"Suhddjrj").children(matching: .button).element(boundBy: 1).tap()
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"ggg")/*[[".cells.containing(.staticText, identifier:\"36 m'\")",".cells.containing(.staticText, identifier:\"ggg\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .button).element(boundBy: 0).tap()

    }

}
