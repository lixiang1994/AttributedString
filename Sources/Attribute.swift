//
//  AttributedStringAttribute.swift
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

extension AttributedStringInterpolation {
    
    public struct Attribute {
        let attributes: [NSAttributedString.Key: Any]
    }
    
    public mutating func appendInterpolation<T>(_ value: T, _ attributes: Attribute...) {
        appendInterpolation(value, with: attributes)
    }
    
    public mutating func appendInterpolation<T>(_ value: T, with attributes: [Attribute]) {
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        self.value.append(.init(string: "\(value)", attributes: temp))
    }
    
    // 包装模式
    public enum WrapMode {
        case embedding(AttributedString)
        case override(AttributedString)
    }
    
    // 嵌套包装
    public mutating func appendInterpolation(wrap string: AttributedString, _ attributes: Attribute...) {
        appendInterpolation(wrap: .embedding(string), with: attributes)
    }
    public mutating func appendInterpolation(wrap mode: WrapMode, _ attributes: Attribute...) {
        appendInterpolation(wrap: mode, with: attributes)
    }
    mutating func appendInterpolation(wrap mode: WrapMode, with attributes: [Attribute]) {
        // 获取通用属性
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        // 创建可变富文本
        let string: NSMutableAttributedString
        switch mode {
        case .embedding(let value):
            string = NSMutableAttributedString(attributedString: value.value)
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
            string = NSMutableAttributedString(attributedString: value.value)
            string.addAttributes(temp, range: .init(location: 0, length: string.length))
        }
        
        self.value.append(string)
    }
}

extension AttributedStringInterpolation.Attribute {
    
    public static func font(_ value: Font) -> Self {
        return .init(attributes: [.font: value])
    }
    
    public static func color(_ value: Color) -> Self {
        return .init(attributes: [.foregroundColor: value])
    }
    
    public static func background(_ value: Color) -> Self {
        return .init(attributes: [.backgroundColor: value])
    }
    
    public static func ligature(_ value: Bool) -> Self {
        return .init(attributes: [.ligature: value ? 1 : 0])
    }
    
    public static func kern(_ value: CGFloat) -> Self {
        return .init(attributes: [.kern: value])
    }
    
    public static func strikethrough(_ style: NSUnderlineStyle, color: Color? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strikethroughColor] = color
        temp[.strikethroughStyle] = style.rawValue
        return .init(attributes: temp)
    }
    
    public static func underline(_ style: NSUnderlineStyle, color: Color? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.underlineColor] = color
        temp[.underlineStyle] = style.rawValue
        return .init(attributes: temp)
    }
    
    public static func link(_ value: String) -> Self {
        guard let url = URL(string: value) else { return .init(attributes: [:])}
        
        return link(url)
    }
    public static func link(_ value: URL) -> Self {
        return .init(attributes: [.link: value])
    }
    
    public static func baselineOffset(_ value: CGFloat) -> Self {
        return .init(attributes: [.baselineOffset: value])
    }
    
    public static func shadow(_ value: NSShadow) -> Self {
        return .init(attributes: [.shadow: value])
    }
    
    public static func stroke(_ width: CGFloat = 0, color: Color? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strokeColor] = color
        temp[.strokeWidth] = width
        return .init(attributes: temp)
    }
    
    public static func textEffect(_ value: String) -> Self {
        return .init(attributes: [.textEffect: value])
    }
    public static func textEffect(_ value: NSAttributedString.TextEffectStyle) -> Self {
        return textEffect(value.rawValue)
    }
    
    public static func obliqueness(_ value: CGFloat = 0.1) -> Self {
        return .init(attributes: [.obliqueness: value])
    }
    
    public static func expansion(_ value: CGFloat = 0.0) -> Self {
        return .init(attributes: [.expansion: value])
    }
    
    public static func writingDirection(_ value: [Int]) -> Self {
        return .init(attributes: [.writingDirection: value])
    }
    public static func writingDirection(_ value: WritingDirection) -> Self {
        return writingDirection(value.value)
    }
    
    public static func verticalGlyphForm(_ value: Bool) -> Self {
        return .init(attributes: [.verticalGlyphForm: value ? 1 : 0])
    }
}

extension AttributedStringInterpolation.Attribute {
    
    public enum WritingDirection {
        case LRE
        case RLE
        case LRO
        case RLO
        
        fileprivate var value: [Int] {
            switch self {
            case .LRE:  return [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.embedding.rawValue]
                
            case .RLE:  return [NSWritingDirection.rightToLeft.rawValue | NSWritingDirectionFormatType.embedding.rawValue]
                
            case .LRO:  return [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.override.rawValue]
                
            case .RLO:  return [NSWritingDirection.rightToLeft.rawValue | NSWritingDirectionFormatType.override.rawValue]
            }
        }
    }
}

@available(iOS 9.0, *)
extension AttributedStringInterpolation.Attribute {
    
    public static func action(_ value: @escaping AttributedString.Action) -> Self {
        return .init(attributes: [.action: value])
    }
}
