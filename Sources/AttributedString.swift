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
    @available(iOS 9.0, *)
    public typealias Action = (NSAttributedString, NSRange) -> Void
    
    public let value: NSAttributedString
    
    init(_ value: NSAttributedString) {
        self.value = value
    }
    
    public init?(_ value: NSAttributedString?) {
        guard let value = value else { return nil }
        self.value = value
    }
    
    public init(_ string: AttributedString, _ attributes: Attribute...) {
        let temp: AttributedString = "\(wrap: .embedding(string), with: attributes)"
        self.value = temp.value
    }
    
    public init(_ string: AttributedString, with attributes: [Attribute]) {
        let temp: AttributedString = "\(wrap: .embedding(string), with: attributes)"
        self.value = temp.value
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
