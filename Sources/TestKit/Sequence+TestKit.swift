//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation

public extension Sequence where Element: Hashable {
    var setRepresentation: Set<Element> {
        return Set(self)
    }
}
