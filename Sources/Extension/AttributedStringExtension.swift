//
//  AttributedStringExtension.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/6/4.
//  Copyright © 2020 LEE. All rights reserved.
//

import Foundation

@available(iOS 9.0, *)
extension NSAttributedString.Key {
    
    static let action = NSAttributedString.Key("com.attributed.string.action")
}

@available(iOS 9.0, *)
extension NSAttributedString {
    
    func contains(_ name: Key) -> Bool {
        var result = false
        enumerateAttribute(
            name,
            in: .init(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (an, range, stop) in
            guard an != nil else { return }
            result = true
            stop.pointee = true
        }
        return result
    }
}
