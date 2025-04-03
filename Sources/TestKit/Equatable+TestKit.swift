//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest

public extension Equatable {
    func assert(equals other: Self, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(self, other, file: file, line: line)
    }
    
    func assert(doesNotEqual other: Self, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertNotEqual(self, other, file: file, line: line)
    }
}
