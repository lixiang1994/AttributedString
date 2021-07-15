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

public class ASAttributedStringWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol ASAttributedStringCompatible {
    associatedtype ASAttributedStringCompatibleType
    var attributed: ASAttributedStringCompatibleType { get }
}

extension ASAttributedStringCompatible {
    
    public var attributed: ASAttributedStringWrapper<Self> {
        get { return ASAttributedStringWrapper(self) }
    }
}

extension ASAttributedString {
    
    /// Add a AttributedString to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString to add.
    public static func += (lhs: inout ASAttributedString, rhs: ASAttributedString) {
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
    public static func + (lhs: ASAttributedString, rhs: ASAttributedString) -> ASAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs.value)
        string.append(rhs.value)
        return .init(string)
    }

    /// Add a String to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: String to add.
    public static func += (lhs: inout ASAttributedString, rhs: String) {
        lhs += ASAttributedString(.init(string: rhs))
    }
    
    /// Add a AttributedString to another String.
    ///
    /// - Parameters:
    ///   - lhs: String to add to.
    ///   - rhs: AttributedString to add.
    public static func += (lhs: inout String, rhs: ASAttributedString) {
        lhs += rhs.value.string
    }

    /// Add a String to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: ASAttributedString, rhs: String) -> ASAttributedString {
        return lhs + ASAttributedString(.init(string: rhs))
    }
    /// Add a AttributedString to another String and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: String to add.
    ///   - rhs: AttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: String, rhs: ASAttributedString) -> ASAttributedString {
        return ASAttributedString(.init(string: lhs)) + rhs
    }
    
    /// Add a NSAttributedString to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    public static func += (lhs: inout ASAttributedString, rhs: NSAttributedString) {
        lhs += ASAttributedString(rhs)
    }
    
    /// Add a AttributedString to another NSMutableAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSMutableAttributedString to add to.
    ///   - rhs: AttributedString to add.
    public static func += (lhs: inout NSMutableAttributedString, rhs: ASAttributedString) {
        lhs.append(rhs.value)
    }

    /// Add a NSAttributedString to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: ASAttributedString, rhs: NSAttributedString) -> ASAttributedString {
        return lhs + ASAttributedString(rhs)
    }
    
    /// Add a AttributedString to another NSAttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: AttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: ASAttributedString) -> ASAttributedString {
        return ASAttributedString(lhs) + rhs
    }
    
    /// Add a AttributedString.Attribute to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Attribute to add.
    public static func += (lhs: inout ASAttributedString, rhs: ASAttributedString.Attribute) {
        lhs += (rhs, .init(location: 0, length: lhs.value.string.count))
    }
    
    /// Add a AttributedString.Attribute to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Attribute to add.
    public static func += (lhs: inout ASAttributedString, rhs: [ASAttributedString.Attribute]) {
        lhs += (rhs, .init(location: 0, length: lhs.value.string.count))
    }
    
    /// Add a AttributedString.Attribute to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Attribute to add.
    public static func += (lhs: inout ASAttributedString, rhs: (ASAttributedString.Attribute, NSRange)) {
        lhs += ([rhs.0], rhs.1)
    }
    
    /// Add a AttributedString.Attribute to another AttributedString.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add to.
    ///   - rhs: AttributedString.Attribute to add.
    public static func += (lhs: inout ASAttributedString, rhs: ([ASAttributedString.Attribute], NSRange)) {
        lhs = lhs + rhs
    }
    
    /// Add a AttributedString.Attribute to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString.Attribute to add.
    /// - Returns: New instance with added AttributedString.Attribute.
    public static func + (lhs: ASAttributedString, rhs: ASAttributedString.Attribute) -> ASAttributedString {
        return lhs + (rhs, .init(location: 0, length: lhs.value.string.count))
    }
    
    /// Add a AttributedString.Attribute to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString.Attribute to add.
    /// - Returns: New instance with added AttributedString.Attribute.
    public static func + (lhs: ASAttributedString, rhs: (ASAttributedString.Attribute, NSRange)) -> ASAttributedString {
        return lhs + ([rhs.0], rhs.1)
    }
    
    /// Add a AttributedString.Attribute to another AttributedString and return a new AttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: AttributedString to add.
    ///   - rhs: AttributedString.Attribute to add.
    /// - Returns: New instance with added AttributedString.Attribute.
    public static func + (lhs: ASAttributedString, rhs: ([ASAttributedString.Attribute], NSRange)) -> ASAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs.value)
        rhs.0.forEach { string.addAttributes($0.attributes, range: rhs.1) }
        return .init(string)
    }
}
