//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest
public extension XCUIElement {
    var ifExists: Self? {
        return self.ifExists()
    }
    
    var center: XCUICoordinate {
        return coordinate(withNormalizedOffset: .init(dx: 0.5, dy: 0.5))
    }
    
    func ifExists(within timeout: TimeInterval = 2.0) -> Self? {
        if exists {
            return self
        }
        
        if waitForExistence(timeout: timeout) {
            return self
        }
        return nil
    }
    
    @discardableResult
    func expectExistence(
        within timeout: TimeInterval = 2.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        if let extant = ifExists(within: timeout) {
            return extant
        } else {
            XCTFail(
                "Element \(description) did not come to existence within the expected duration of \(timeout) seconds.",
                file: file,
                line: line)
        }
        return self
    }
    
    @objc var valueAsString: String? {
        value as? String
    }
    
    var valueAsStringOrEmpty: String {
        (value as? String) ?? ""
    }
    
    func assertNil(file: StaticString = #filePath, line: UInt = #line) {
        if self.exists {
            XCTFail(
                "Assumed nil, but found existence for \(self.elementType)-\(self.identifier)",
                file: file,
                line: line)
        }
    }
    func assertNotNil(file: StaticString = #filePath, line: UInt = #line) {
        if !self.exists {
            XCTFail(
                "Assumed existence, but found nil for \(self.elementType)-\(self.identifier)",
                file: file,
                line: line)
        }
    }
    
    func addScreenshot(
        to activity: XCTActivity,
        name: String? = nil,
        function: StaticString = #function
    ) {
        let screenshot = self.screenshot()
        let defaultDescriptor = "\(self.elementType.description)-\(self.identifier)"
        let name = "MLBUITest-Screenshot-\(function)-\(name ?? defaultDescriptor).png"
        let attachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: name,
            payload: screenshot.pngRepresentation,
            userInfo: .none
        )
        attachment.lifetime = .keepAlways
        activity.add(attachment)
    }
    
    func tapAnd() -> Self {
        tap()
        return self
    }
    
    func expect(toFindCell identifier: String, file: StaticString = #filePath, line: UInt = #line) -> XCUIElement {
        if let found = scroll(toFindCell: identifier) {
            return found
        }
        XCTFail("Expected to find [\(identifier)], but did not.", file: file, line: line)
        return cells[identifier] //return what the system gives us
    }
    
    func scroll(toFindCell identifier: String) -> XCUIElement? {
        let elementType = elementType
        guard [.collectionView, .table].contains(elementType) else {
            fatalError("XCUIElement is not a collectionView or a table.")
        }
        
        var reachedTheEnd = false
        var allVisibleElements = [String]()
        
        while !reachedTheEnd {
            XCTContext.runActivity(named: "Searching for \(identifier) in \(elementType.description)") { _ in }
            if let cell = cells[identifier].ifExists {
                XCTContext.runActivity(named: "Cell found!") { _ in }
                return cell
            }
            
            let allElements = cells.allElementsBoundByIndex.map({$0.identifier})
            

            reachedTheEnd = (allElements == allVisibleElements)
            allVisibleElements = allElements
            
            XCTContext.runActivity(named: "Cannot find cell in visible \(elementType.description), scrolling up") { _ in
                let startCoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.9))
                startCoordinate.press(forDuration: 0.01, thenDragTo: self.coordinate(withNormalizedOffset:CGVector(dx: 0.99, dy: 0.1)))
            }
        }
        XCTContext.runActivity(named: "\(identifier) not found in \(elementType)") { _ in }
        return nil
    }
}
