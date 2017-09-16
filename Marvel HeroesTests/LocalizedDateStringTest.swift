//
//  LocalizedDateStringTest.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 16/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import XCTest

class LocalizedDateStringTest: XCTestCase {

    
    override func tearDown() {
        
    }
    
    override func setUp() {
        
    }
    
    func testDateLocalizedStringWithStyles() {
        let date = Date(timeIntervalSince1970: 10000)
        let localizedString = date.localizedString(withDateStyle: .short, andTimeStyle: .none)
        
        XCTAssertTrue(localizedString == "12/31/69", "Unexpected localized string from style")
    }
    
    func testDateLocalizedStringWithTemplate() {
        let date = Date(timeIntervalSince1970: 10000)
        let localizedString = date.localizedString(withTemplate: "ddMMyyyy")
        
        XCTAssertTrue(localizedString == "12/31/1969", "Unexpected localized string form template")
    }
}
