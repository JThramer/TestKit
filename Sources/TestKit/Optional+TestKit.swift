//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest

public extension Optional {
    func assertNil(file: StaticString = #filePath, line: UInt = #line) {
        if case .some(let wrapped) = self {
            XCTFail(
                "Nil expected, but \(String(describing: wrapped)) found instead.",
                file: file,
                line: line)
        }
    }
    
    func assertNotNil(file: StaticString = #filePath, line: UInt = #line) {
        if case .none = self {
            XCTFail("Value expected, but nil was found.",
                    file: file,
                    line: line)
        }
    }
}
