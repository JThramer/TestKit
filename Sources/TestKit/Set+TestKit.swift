//
//  File.swift
//  TestKit
//
//  Created by Jerrad Thramer on 4/2/25.
//

import Foundation

public extension Set {
    var nonEmpty: Self? {
        return isEmpty ? .none : self
    }
}
