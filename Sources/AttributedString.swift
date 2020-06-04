//
//  AttributedString.swift
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
public typealias Image = NSImage
public typealias Color = NSColor
public typealias Font = NSFont
#else
import UIKit
public typealias Image = UIImage
public typealias Color = UIColor
public typealias Font = UIFont
#endif

public struct AttributedString {
    
    public typealias Attribute = AttributedStringInterpolation.Attribute
    public typealias WrapMode = AttributedStringInterpolation.WrapMode
    
    public let value: NSAttributedString
    
    /// NSAttributedString
    
    init(_ value: NSAttributedString) {
        self.value = value
    }
    
    /// NSAttributedString + attributes
    
    public init(_ value: NSAttributedString, _ attributes: Attribute...) {
        self.value = AttributedString(value, with: attributes).value
    }
    
    public init?(_ value: NSAttributedString?, _ attributes: Attribute...) {
        guard let value = value else { return nil }
        self.value = AttributedString(value, with: attributes).value
    }
    
    public init(_ value: NSAttributedString, with attributes: [Attribute] = []) {
        if attributes.isEmpty {
            self.value = AttributedString(.init(value)).value
            
        } else {
            self.value = AttributedString(.init(value), with: attributes).value
        }
    }
    
    public init?(_ value: NSAttributedString?, with attributes: [Attribute] = []) {
        guard let value = value else { return nil }
        self.value = AttributedString(.init(value), with: attributes).value
    }
    
    /// AttributedString + attributes
    
    public init(_ string: AttributedString, _ attributes: Attribute...) {
        self.value = AttributedString(wrap: .embedding(string), with: attributes).value
    }
    
    public init(_ string: AttributedString, with attributes: [Attribute]) {
        self.value = AttributedString(wrap: .embedding(string), with: attributes).value
    }
    
    public init(wrap mode: WrapMode, _ attributes: Attribute...) {
        let temp: AttributedString = "\(wrap: mode, with: attributes)"
        self.value = temp.value
    }
    
    public init(wrap mode: WrapMode, with attributes: [Attribute]) {
        let temp: AttributedString = "\(wrap: mode, with: attributes)"
        self.value = temp.value
    }
}

extension AttributedString: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.value = .init(string: value)
    }
}

extension AttributedString: CustomStringConvertible {
    
    public var description: String {
        .init(describing: value)
    }
}
