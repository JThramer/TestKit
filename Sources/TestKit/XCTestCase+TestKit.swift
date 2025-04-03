//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest

public extension XCTestCase {
    
    var app: XCUIApplication { return .shared }
    typealias PartialElementPath = PartialKeyPath<XCUIElement>
    typealias ElementPath<T> = KeyPath<XCUIElement, T>
    typealias BooleanElementPath = ElementPath<Bool>
    
    
    func wait(for interval: TimeInterval, because reason: String? = nil) {
        let expectation = XCTestExpectation()
        expectation.isInverted = true
        let waiter = XCTWaiter()
        let reasonExists = !(reason?.isEmpty ?? true)
        let becauseReason = reasonExists ? "(reason: \(reason ?? ""))" : "<none>"
        _ = XCTContext.runActivity(named: "Manually waiting for \(interval) seconds \(becauseReason)...") { _ in
            waiter.wait(for: [expectation], timeout: interval)
        }
    }
    
    
    func expectChange(
        in element: XCUIElement,
        path: PartialElementPath?,
        timeout: TimeInterval = 5.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let keyPath: PartialElementPath = path ?? \.valueAsString
        let oldValue = element[keyPath: keyPath]
        let predicate = NSPredicate(
            format: "%K != %@", argumentArray: [keyPath, (oldValue as Any)]
        )
        
        let expectation = expectation(for: predicate, evaluatedWith: element)
        runActivity(
            with: expectation,
            on: element.description,
            timeout: timeout,
            action: "change",
            file: file,
            line: line
        )
        
    }
    
    func expectAppearance(
        anyOf elements: [XCUIElement],
        timeout: TimeInterval = 5.0,
        handler: @escaping ([XCUIElement]) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line) {
            
            let test = NSPredicate { arr, _ in
                guard let array = arr as? [XCUIElement]
                else { return false }
                
                let resolved = array.map { $0.firstMatch }
                let matches = resolved.filter({ $0.exists })
                guard !matches.isEmpty else { return false }
                let descriptions = matches.map { $0.identifier }
                let arrayDescriptions = descriptions.joined(separator: " & ")
                let finalDescription = matches.count == 1 ? descriptions.first?.description ?? "" : arrayDescriptions
                XCTContext.runActivity(named: "Matched \(finalDescription) existence.") { _ in }
                return true
            }
            
            let expectation = XCTNSPredicateExpectation(predicate: test, object: elements)
            expectation.handler = {
                let resolved = elements.map(\.firstMatch)
                let matches =  resolved.filter(\.exists)
                
                handler(matches)
                return true
            }
            
            let descriptions = elements.map { $0.description }
            let description = descriptions.joined(separator: " or ")
            
            runActivity(
                with: expectation,
                on: description,
                timeout: timeout,
                action: "appear",
                file: file,
                line: line
            )
            
        }
    
    func expectDisappearance(
        in element: XCUIElement,
        timeout: TimeInterval = 5.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let predicate = NSPredicate(block: { elem, _ in
            guard let ui = elem as? XCUIElement,
                  ui.exists == false,
                  ui.isHittable == false else { return false }
            XCTContext.runActivity(named: "\(element.description) has disappeared.") { _ in }
            return true
        })
        
        
        let expectation = expectation(for: predicate, evaluatedWith: element)
        runActivity(
            with: expectation,
            on: element.description,
            timeout: timeout,
            action: "disappear",
            file: file,
            line: line
        )
    }
    
    func expectTapability(
        in element: XCUIElement,
        toBe value: Bool? = nil,
        timeout: TimeInterval = 5.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {    
        expect(
            \.isHittable,
             in: element,
             toBe: value,
             timeout: timeout,
             description: "is tappable",
             file: file,
             line: line
        )
    }
    
    func expect(
        _ condition: BooleanElementPath,
        in element: XCUIElement,
        toBe value: Bool? = nil,
        timeout: TimeInterval = 5.0,
        description actionDescription: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedValue: Bool = value ?? true
        expect(
            condition,
            in: element,
            toBe: expectedValue,
            timeout: timeout,
            description: actionDescription,
            file: file,
            line: line
        )
        
        
        
        
        let predicate = NSPredicate(
            format: "%K == \(expectedValue)",
            argumentArray: [condition]
        )
        
        let expectation = expectation(for: predicate, evaluatedWith: element)
        runActivity(
            with: expectation,
            on: element.description,
            timeout: timeout,
            action: actionDescription ?? "for \(condition)) to be \(expectedValue)",
            file: file,
            line: line
        )
    }
    
    func expect<T: Equatable>(
        _ path: ElementPath<T>,
        in element: XCUIElement,
        toBe expectedValue: T,
        timeout: TimeInterval = 5.0,
        description actionDescription: String? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let predicate = NSPredicate(
            format: "%K == \(expectedValue)",
            argumentArray: [path]
        )
        
        let expectation = expectation(for: predicate, evaluatedWith: element)
        runActivity(
            with: expectation,
            on: element.description,
            timeout: timeout,
            action: actionDescription ?? "for \(path) to be \(expectedValue)",
            file: file,
            line: line
        )
    }
    
    private func runActivity(
        with expectation: XCTestExpectation,
        on description: String,
        timeout: TimeInterval,
        action: String,
        file: StaticString,
        line: UInt) {
            XCTContext.runActivity(
                named: "Waiting up to \(timeout) seconds for \(description) to \(action)..."
            ) { _ in
                let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
                XCTAssertEqual(
                    result, .completed,
                    "Timed out after \(timeout) seconds waiting for \(description) to \(action)",
                    file: file, line: line)
            }
        }
}
