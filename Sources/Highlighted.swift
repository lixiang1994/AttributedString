//
//  Highlighted.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/6/21.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension AttributedString {
    
    public mutating func highlighted(_ checkings: [Checking] = .all, _ attributes: Attribute...) {
        highlighted(checkings, attributes)
    }
    
    public mutating func highlighted(_ checkings: [Checking] = .all, _ attributes: [Attribute]) {
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach {
            string.addAttributes(temp, range: $0.0)
        }
        
        self.value = string
    }
}

public extension Array where Element == AttributedString.Checking {
    
    static var all: [AttributedString.Checking] = AttributedString.Checking.allCases
    
    static let empty: [AttributedString.Checking] = []
}
