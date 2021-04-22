//
//  Alpha_StockTests.swift
//  Alpha StockTests
//
//  Created by Prince Alvin Yusuf on 13/04/21.
//

import XCTest
@testable import Alpha_Stock

class Alpha_StockTests: XCTestCase {
    // expectation
    
    // MARK: - Test User Defaults is Saving Data or Not # Intraday #
    func testUserDefaultsInIntraday() {
        
        let intradayViewController = IntradayViewController()
        let expression = intradayViewController.userDefaults.string(forKey: "stockLabel")
        
        XCTAssertNotNil(expression)
    }
    
    // MARK: - Test User Defaults is Saving Data or Not # Custom #
    func testUserDefaultsInCustom() {
        
        let customViewController = CustomViewController()
        let expressionOne = customViewController.userDefaults.string(forKey: "intervalChooser")
        let expressionTwo = customViewController.userDefaults.string(forKey: "outputsizeChooser")
        
        XCTAssertNotNil(expressionOne, "Interval is Available")
        XCTAssertNotNil(expressionTwo, "Outputsize is Available")
    }
    
    // MARK: - Test IF Keychain is already Encrypted The Data
    func testIfKeychainAlreadyEncryptTheData() {
        let customViewController = CustomViewController()
        let apiKey = customViewController.apiKey
        for index in 0...3 {
            let dataString = Data(from: apiKey[index])
            let dataStatus = KeyChain.save(key: "apiChooser", data: dataString)
            XCTAssertEqual(dataStatus, 0)
        }
        
    }
    
    // MARK: - Test IF Keychain Contain The Data
    func testIfKeychainContainTheData() {
        guard let receiveData = KeyChain.load(key: "apiChooser") else { fatalError() }
        let resultAPI = receiveData.to(type: String.self)
        XCTAssertNotNil(resultAPI, "API is Available")
        
    }
    
    
}
