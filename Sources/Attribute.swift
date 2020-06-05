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

extension AttributedString {
    
    /// 属性
    public struct Attribute {
        let attributes: [NSAttributedString.Key: Any]
    }
    
    /// 包装模式
    public enum WrapMode {
        case embedding(AttributedString)        // 嵌入模式
        case override(AttributedString)         // 覆盖模式
        
        internal var value: AttributedString {
            switch self {
            case .embedding(let value):     return value
            case .override(let value):      return value
            }
        }
    }
}

extension AttributedString.Attribute {
    
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

extension AttributedString.Attribute {
    
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

extension AttributedStringInterpolation {
    
    public typealias Attribute = AttributedString.Attribute
    public typealias WrapMode = AttributedString.WrapMode
    
    public mutating func appendInterpolation<T>(_ value: T, _ attributes: Attribute...) {
        appendInterpolation(value, with: attributes)
    }
    
    public mutating func appendInterpolation<T>(_ value: T, with attributes: [Attribute]) {
        self.value.append(AttributedString(.init(value), with: attributes).value)
    }
    
    // 嵌套包装
    public mutating func appendInterpolation(wrap string: AttributedString, _ attributes: Attribute...) {
        appendInterpolation(wrap: string, with: attributes)
    }
    public mutating func appendInterpolation(wrap string: AttributedString, with attributes: [Attribute]) {
        self.value.append(AttributedString(wrap: .embedding(string), with: attributes).value)
    }
    public mutating func appendInterpolation(wrap mode: WrapMode, _ attributes: Attribute...) {
        appendInterpolation(wrap: mode, with: attributes)
    }
    public mutating func appendInterpolation(wrap mode: WrapMode, with attributes: [Attribute]) {
        self.value.append(AttributedString(wrap: mode, with: attributes).value)
    }
}
