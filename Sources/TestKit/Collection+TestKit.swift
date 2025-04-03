//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest

public extension Collection where Element: Hashable {
    func assert(contains other: Element, file: StaticString = #filePath, line: UInt = #line) {
        if self.firstIndex(of: other) == nil {
            XCTFail(
                "Element \(String(describing: other)) expected, but not found.",
                file: file,
                line: line)
        }
    }
    func assert(doesNotContain other: Element, file: StaticString = #filePath, line: UInt = #line) {
        if let index = self.firstIndex(of: other) {
            XCTFail(
                "Element \(String(describing: other)) not expected, but found at index \(index).",
                file: file,
                line: line)
        }
    }
}

public extension Collection where Self.Index == Int {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
