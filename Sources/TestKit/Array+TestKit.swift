//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation

import XCTest
public extension Array where Element: XCUIElement {
    typealias ElementPath<T> = KeyPath<XCUIElement, T>
    
    @discardableResult
    func expectExistence(
        within timeout: TimeInterval = 2.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        forEach { $0.expectExistence(within: timeout, file: file, line: line) }
        return self
    }
    
    
    func assert(containsOnly elements: [XCUIElement], file: StaticString = #filePath, line: UInt = #line) {
        if count != elements.count {
            XCTFail("Count of elements differs from expected.", file: file, line: line)
        } else {
            assert(contains: elements, file: file, line: line)
        }
    }
    
    
    func assert(contains elements: [XCUIElement], file: StaticString = #filePath, line: UInt = #line) {
        let elems = elements[\.identifier].setRepresentation
        let idents = self[\.identifier].setRepresentation
        
        if let fails = elems.subtracting(idents).nonEmpty {
            XCTFail("Elements not found in collection: \(fails)", file: file, line: line)
        }
    }
    
    
    func tap() {
        forEach { $0.tap() }
    }
    
    func map<T>(keyPath path: ElementPath<T>) -> [T] {
        return map { $0[keyPath: path] }
    }
    
    subscript<T>(keyPath: ElementPath<T>) -> [T] {
        map(keyPath: keyPath)
    }
}

