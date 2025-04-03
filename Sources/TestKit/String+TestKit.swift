//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest

public extension String {
    func assert(contains other: String, file: StaticString = #filePath, line: UInt = #line) {
        if self.range(of: other) == nil {
            XCTFail(
                "Element \(String(describing: other)) expected, but not found.",
                file: file,
                line: line)
        }
    }
    
    func assert(doesNotContain other: String, file: StaticString = #filePath, line: UInt = #line) {
        if let range = self.range(of: other) {
            XCTFail(
                "Element \(String(describing: other)) not expected, but found at range \(range).",
                file: file,
                line: line)
        }
    }
}
