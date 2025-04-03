//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation
import SwiftUI
import XCTest

@propertyWrapper
public struct UI: DynamicProperty {
    public typealias ElementPath = KeyPath<XCUIElement, XCUIElementQuery>
    let keyPath: ElementPath
    let key: String
    let app: XCUIApplication
    
    
    public var wrappedValue: XCUIElement {
        return app[keyPath: keyPath][key]
    }
    
    public init(_ keyPath: ElementPath, _ key: String, app: XCUIApplication? = nil) {
        self.keyPath = keyPath
        self.key = key
        self.app = app ?? .shared
    }
}


public extension TestKit.UI {
    @propertyWrapper
    struct All: DynamicProperty {
        public typealias Filter = (XCUIElement) -> Bool
        public typealias ElementPath = KeyPath<XCUIElement, XCUIElementQuery>
        let keyPath: ElementPath
        let key: String?
        let filter: Filter?
        let app: XCUIApplication
        
        
        public var wrappedValue: [XCUIElement] {
            return app[keyPath: keyPath].matches.filter {
                var containsTest = true
                var filterTest = true
                if let key = key {
                    containsTest = $0.identifier.contains(key) || $0.label.contains(key)
                }
                if let filter = filter {
                    filterTest = filter($0)
                }
                
                return containsTest && filterTest
            }
        }
        
        
        public init(_ keyPath: ElementPath, matching key: String? = nil, app: XCUIApplication? = nil, filter: Filter? = nil ) {
            self.keyPath = keyPath
            self.key = key
            self.app = app ?? .shared
            self.filter = filter
        }
    }
}

