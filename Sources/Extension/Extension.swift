//
//  Extension.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2019/11/18.
//  Copyright © 2019 LEE. All rights reserved.
//

import Foundation

public class AttributedStringWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol AttributedStringCompatible {
    associatedtype AttributedStringCompatibleType
    var attributed: AttributedStringCompatibleType { get }
}

extension AttributedStringCompatible {
    
    public var attributed: AttributedStringWrapper<Self> {
        get { return AttributedStringWrapper(self) }
    }
}


extension AttributedString {
    
    /// Add a AttributedString to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString to add.
    public static func += (lhs: inout AttributedString, rhs: AttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs.value)
        string.append(rhs.value)
        lhs = .init(string)
    }

    /// Add a AttributedString to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: AttributedString, rhs: AttributedString) -> AttributedString {
        let string = NSMutableAttributedString(attributedString: lhs.value)
        string.append(rhs.value)
        return .init(string)
    }

    /// Add a AttributedString to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    public static func += (lhs: inout AttributedString, rhs: String) {
        lhs += AttributedString(.init(string: rhs))
    }

    /// Add a NSAttributedString to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: AttributedString, rhs: String) -> AttributedString {
        return lhs + AttributedString(.init(string: rhs))
    }
}
