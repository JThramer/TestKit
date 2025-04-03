//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import XCTest

public extension XCUIElementQuery {
    typealias ElementClause = (XCUIElement) -> Bool
    func filter(where clause: ElementClause) -> [XCUIElement] {
        return matches.filter(clause)
    }
    
    var matches: [XCUIElement] {
        return matches()
    }
    
    func matches(by type: MatchType = .index) -> [XCUIElement] {
        switch type {
        case .index:
            return allElementsBoundByIndex
        case .identifier:
            return allElementsBoundByAccessibilityElement
        }
    }
}


public extension XCUIElementQuery {
    enum MatchType {
        case index, identifier
    }
}
