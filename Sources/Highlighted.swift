//
//  Highlighted.swift
//  AttributedString-iOS
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
    
    struct Highlighted {
        let attributes: [NSAttributedString.Key: Any]
        let matched: [(NSRange, AttributedString.Checking.Result)]
    }
}

extension AttributedString {
    
    public mutating func highlighted(checkings: [Checking], _ highlightes: [Attribute]) {
        var temp: [NSAttributedString.Key: Any] = [:]
        highlightes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach { string.addAttributes(temp, range: $0.0) }
        // 存储高亮配置
        string.addAttribute(
            .highlighted,
            value: Highlighted(attributes: temp, matched: matched),
            range: .init(location: 0, length: string.length)
        )
        
        self.value = string
    }
}

extension NSAttributedString.Key {
    
    static let highlighted = NSAttributedString.Key("com.attributed.string.highlighted")
}

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    
    static func == (lhs: [NSAttributedString.Key: Any], rhs: [NSAttributedString.Key: Any]) -> Bool {
        lhs.keys == rhs.keys ? NSDictionary(dictionary: lhs).isEqual(to: rhs) : false
    }
}

extension Array where Element == (NSRange, [NSAttributedString.Key: Any]) {
    
    static func == (lhs: [(NSRange, [NSAttributedString.Key: Any])], rhs: [(NSRange, [NSAttributedString.Key: Any])]) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        return zip(lhs, rhs).allSatisfy { (l, r) -> Bool in
            l.0 == r.0 && l.1 == r.1
        }
    }
}
