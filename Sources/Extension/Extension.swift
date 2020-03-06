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
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString to add.
    /// - Returns: New instance with added AttributedString.
    public static func + (lhs: AttributedString, rhs: AttributedString) -> AttributedString {
        let string = NSMutableAttributedString(attributedString: lhs.value)
        string.append(rhs.value)
        return .init(string)
    }

    /// Add a String to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: String to add.
    public static func += (lhs: inout AttributedString, rhs: String) {
        lhs += AttributedString(.init(string: rhs))
    }
    
    /// Add a AttributedString to another String.
    ///
    /// - Parameters:
    ///   - lhs: String to add to.
    ///   - rhs: AttributedString to add.
    public static func += (lhs: inout String, rhs: AttributedString) {
        lhs += rhs.value.string
    }

    /// Add a String to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: AttributedString, rhs: String) -> AttributedString {
        return lhs + AttributedString(.init(string: rhs))
    }
    
    /// Add a NSAttributedString to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    public static func += (lhs: inout AttributedString, rhs: NSAttributedString) {
        lhs += AttributedString(rhs)
    }
    
    /// Add a AttributedString to another NSMutableAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSMutableAttributedString to add to.
    ///   - rhs: AttributedString to add.
    public static func += (lhs: inout NSMutableAttributedString, rhs: AttributedString) {
        lhs.append(rhs.value)
    }

    /// Add a NSAttributedString to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: AttributedString, rhs: NSAttributedString) -> AttributedString {
        return lhs + AttributedString(rhs)
    }
    
    /// Add a AttributedString.Style to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Style to add.
    public static func += (lhs: inout AttributedString, rhs: AttributedString.Style) {
        lhs += (rhs, .init(location: 0, length: lhs.value.string.count))
    }
    
    /// Add a AttributedString.Style to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Style to add.
    public static func += (lhs: inout AttributedString, rhs: (AttributedString.Style, NSRange)) {
        lhs += ([rhs.0], rhs.1)
    }
    
    /// Add a AttributedString.Style to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Style to add.
    public static func += (lhs: inout AttributedString, rhs: ([AttributedString.Style], NSRange)) {
        lhs = lhs + rhs
    }
    
    /// Add a AttributedString.Style to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString.Style to add.
    /// - Returns: New instance with added AttributedString.Style.
    public static func + (lhs: AttributedString, rhs: AttributedString.Style) -> AttributedString {
        return lhs + (rhs, .init(location: 0, length: lhs.value.string.count))
    }
    
    /// Add a AttributedString.Style to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString.Style to add.
    /// - Returns: New instance with added AttributedString.Style.
    public static func + (lhs: AttributedString, rhs: (AttributedString.Style, NSRange)) -> AttributedString {
        return lhs + ([rhs.0], rhs.1)
    }
    
    /// Add a AttributedString.Style to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString.Style to add.
    /// - Returns: New instance with added AttributedString.Style.
    public static func + (lhs: AttributedString, rhs: ([AttributedString.Style], NSRange)) -> AttributedString {
        let string = NSMutableAttributedString(attributedString: lhs.value)
        rhs.0.forEach { string.addAttributes($0.attributes, range: rhs.1) }
        return .init(string)
    }
}
