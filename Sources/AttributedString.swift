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

import Foundation

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
    
    public typealias Style = AttributedStringInterpolation.Style
    
    public let value: NSAttributedString
    
    init(_ value: NSAttributedString) {
        self.value = value
    }
    
    public init?(_ value: NSAttributedString?) {
        guard let value = value else { return nil }
        self.value = value
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
