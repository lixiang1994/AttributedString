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
    
    public internal(set) var value: NSAttributedString
    
    public var length: Int {
        value.length
    }
    
    /// String
    
    public init(string value: String, _ attributes: Attribute...) {
        self.value = AttributedString(string: value, with: attributes).value
    }
    
    public init(string value: String, with attributes: [Attribute] = []) {
        self.value = AttributedString(.init(string: value), with: attributes).value
    }
    
    /// NSAttributedString
    
    public init(_ value: NSAttributedString) {
        self.value = value
    }
    
    public init(_ value: NSAttributedString, _ attributes: Attribute...) {
        self.value = AttributedString(value, with: attributes).value
    }
    
    public init?(_ value: NSAttributedString?, _ attributes: Attribute...) {
        guard let value = value else { return nil }
        self.value = AttributedString(value, with: attributes).value
    }
    
    public init(_ value: NSAttributedString, with attributes: [Attribute]) {
        self.value = AttributedString(.init(value), with: attributes).value
    }
    
    public init?(_ value: NSAttributedString?, with attributes: [Attribute] = []) {
        guard let value = value else { return nil }
        self.value = AttributedString(.init(value), with: attributes).value
    }
    
    /// AttributedString
    
    public init(_ string: AttributedString, _ attributes: Attribute...) {
        self.value = AttributedString(wrap: .embedding(string), with: attributes).value
    }
    
    public init(_ string: AttributedString, with attributes: [Attribute] = []) {
        self.value = AttributedString(wrap: .embedding(string), with: attributes).value
    }
    
    public init(wrap mode: WrapMode, _ attributes: Attribute...) {
        self.value = AttributedString(wrap: mode, with: attributes).value
    }
    
    public init(wrap mode: WrapMode, with attributes: [Attribute]) {
        guard !attributes.isEmpty else {
            self.value = mode.value.value
            return
        }
        
        // 获取通用属性
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        // 创建可变富文本
        let string: NSMutableAttributedString
        switch mode {
        case .embedding(let value):
            string = .init(attributedString: value.value)
            // 过滤后的属性以及范围
            var ranges: [([NSAttributedString.Key: Any], NSRange)] = []
            // 遍历原属性 去除重复属性 防止覆盖
            string.enumerateAttributes(
                in: .init(location: 0, length: string.length),
                options: .longestEffectiveRangeNotRequired
            ) { (attributs, range, stop) in
                // 差集 从通用属性中过滤掉原本就存在的属性
                let keys = Set(temp.keys).subtracting(Set(attributs.keys))
                ranges.append((temp.filter { keys.contains($0.key) }, range))
            }
            // 添加过滤后的属性和相应的范围
            ranges.forEach { string.addAttributes($0, range: $1) }
            
        case .override(let value):
            string = .init(attributedString: value.value)
            string.addAttributes(temp, range: .init(location: 0, length: string.length))
        }
        
        self.value = string
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

extension AttributedString: Equatable {
    
    public static func == (lhs: AttributedString, rhs: AttributedString) -> Bool {
        guard lhs.length == rhs.length else {
            return false
        }
        guard lhs.value.string == rhs.value.string else {
            return false
        }
        guard lhs.value.get(.init(location: 0, length: lhs.length)) == rhs.value.get(.init(location: 0, length: rhs.length)) else {
            return false
        }
        return true
    }
    
    /// 内容是否相等
    /// - Parameter other: 其他AttributedString
    /// - Returns: 结果
    public func isContentEqual(to other: AttributedString?) -> Bool {
        guard let other = other else {
            return false
        }
        guard length == other.length else {
            return false
        }
        return value.string == other.value.string
    }
}

extension AttributedString {
    
    public mutating func add(attributes: [Attribute], range: NSRange) {
        guard !attributes.isEmpty, range.length > 0 else { return }
        
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let string = NSMutableAttributedString(attributedString: value)
        string.addAttributes(temp, range: range)
        value = string
    }
    
    public mutating func set(attributes: [Attribute], range: NSRange) {
        guard !attributes.isEmpty, range.length > 0 else { return }
        
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        let string = NSMutableAttributedString(attributedString: value)
        string.setAttributes(temp, range: range)
        value = string
    }
}

fileprivate extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    
    static func == (lhs: [NSAttributedString.Key: Any], rhs: [NSAttributedString.Key: Any]) -> Bool {
        lhs.keys == rhs.keys ? NSDictionary(dictionary: lhs).isEqual(to: rhs) : false
    }
}

fileprivate extension Dictionary where Key == NSRange, Value == [NSAttributedString.Key: Any]  {
    
    static func == (lhs: [NSRange: [NSAttributedString.Key: Any]], rhs: [NSRange: [NSAttributedString.Key: Any]]) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        return zip(lhs, rhs).allSatisfy { (l, r) -> Bool in
            l.0 == r.0 && l.1 == r.1
        }
    }
}
