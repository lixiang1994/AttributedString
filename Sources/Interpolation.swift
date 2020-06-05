//
//  AttributedStringInterpolation.swift
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

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension AttributedString: ExpressibleByStringInterpolation {
    
    public init(stringInterpolation: AttributedStringInterpolation) {
        self.value = .init(attributedString: stringInterpolation.value)
    }
}

public struct AttributedStringInterpolation : StringInterpolationProtocol {
    
    let value: NSMutableAttributedString
    
    public init(literalCapacity: Int, interpolationCount: Int) {
        value = .init()
    }
    
    public mutating func appendLiteral(_ literal: String) {
        self.value.append(.init(string: literal))
    }
    
    public mutating func appendInterpolation(_ value: NSAttributedString) {
        self.value.append(value)
    }
    
    /// Interpolates the given value's textual representation into the
    /// attributed string literal being created.
    ///
    /// Do not call this method directly. It is used by the compiler when
    /// interpreting string interpolations. Instead, use string
    /// interpolation to create a new string by including values, literals,
    /// variables, or expressions enclosed in parentheses, prefixed by a
    /// backslash (`\(`...`, attributes: [:])`).
    ///
    ///     let price = 2
    ///     let number = 3
    ///     let message: AttributedString = """
    ///                   If one cookie costs \(price, attributes: [.foregroundColor: UIColor.red]) dollars, \
    ///                   \(number, attributes: [.foregroundColor: UIColor.gray]) cookies cost \(price * number, attributes: [.foregroundColor: UIColor.blue]) dollars.
    ///                   """
    ///
    public mutating func appendInterpolation<T>(_ value: T, attributes: [NSAttributedString.Key: Any]) {
        self.value.append(.init(string: "\(value)", attributes: attributes))
    }
    
    /// Interpolates the given value's textual representation into the
    /// attributed string literal being created.
    ///
    /// Do not call this method directly. It is used by the compiler when
    /// interpreting string interpolations. Instead, use string
    /// interpolation to create a new string by including values, literals,
    /// variables, or expressions enclosed in parentheses, prefixed by a
    /// backslash (`\(`...`)`).
    ///
    ///     let price = 2
    ///     let number = 3
    ///     let message = """
    ///                   If one cookie costs \(price) dollars, \
    ///                   \(number) cookies cost \(price * number) dollars.
    ///                   """
    ///     print(message)
    ///
    ///     // Prints "If one cookie costs 2 dollars, 3 cookies cost 6 dollars."
    ///
    public mutating func appendInterpolation<T>(_ value: T) {
        self.value.append(.init(string: "\(value)"))
    }
}
