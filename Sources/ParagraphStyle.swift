//
//  AttributedStringParagraphStyle.swift
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

extension AttributedString.Attribute {
    
    /// 段落
    /// - Parameter value: 段落样式
    /// - Returns: 属性
    public static func paragraph(_ value: ParagraphStyle...) -> Self {
        return .init(attributes: [.paragraphStyle: ParagraphStyle.get(value)])
    }
}

extension AttributedString.Attribute {
    
    public struct ParagraphStyle {
        
        fileprivate enum Key {
            case lineSpacing                // CGFloat
            case paragraphSpacing           // CGFloat
            case alignment                  // NSTextAlignment
            case firstLineHeadIndent        // CGFloat
            case headIndent                 // CGFloat
            case tailIndent                 // CGFloat
            case lineBreakMode              // NSLineBreakMode
            case minimumLineHeight          // CGFloat
            case maximumLineHeight          // CGFloat
            case baseWritingDirection       // NSWritingDirection
            case lineHeightMultiple         // CGFloat
            case paragraphSpacingBefore     // CGFloat
            case hyphenationFactor          // Float
            case tabStops                   // [NSTextTab]
            case defaultTabInterval         // CGFloat
            case allowsDefaultTighteningForTruncation   // Bool
        }
        
        fileprivate let style: [Key: Any]
        
        fileprivate static func get(_ attributes: [ParagraphStyle]) -> NSParagraphStyle {
            var temp: [Key: Any] = [:]
            attributes.forEach { temp.merge($0.style, uniquingKeysWith: { $1 }) }
            
            func fetch<Value>(_ key: Key, completion: (Value)->()) {
                guard let value = temp[key] as? Value else { return }
                completion(value)
            }
            
            let paragraph = NSMutableParagraphStyle()
            fetch(.lineSpacing) { paragraph.lineSpacing = $0 }
            fetch(.paragraphSpacing) { paragraph.paragraphSpacing = $0 }
            fetch(.alignment) { paragraph.alignment = $0 }
            fetch(.firstLineHeadIndent) { paragraph.firstLineHeadIndent = $0 }
            fetch(.headIndent) { paragraph.headIndent = $0 }
            fetch(.tailIndent) { paragraph.tailIndent = $0 }
            fetch(.lineBreakMode) { paragraph.lineBreakMode = $0 }
            fetch(.minimumLineHeight) { paragraph.minimumLineHeight = $0 }
            fetch(.maximumLineHeight) { paragraph.maximumLineHeight = $0 }
            fetch(.baseWritingDirection) { paragraph.baseWritingDirection = $0 }
            fetch(.lineHeightMultiple) { paragraph.lineHeightMultiple = $0 }
            fetch(.paragraphSpacingBefore) { paragraph.paragraphSpacingBefore = $0 }
            fetch(.hyphenationFactor) { paragraph.hyphenationFactor = $0 }
            fetch(.tabStops) { paragraph.tabStops = $0 }
            fetch(.defaultTabInterval) { paragraph.defaultTabInterval = $0 }
            fetch(.allowsDefaultTighteningForTruncation) { paragraph.allowsDefaultTighteningForTruncation = $0 }
            return paragraph
        }
    }
}

extension AttributedString.Attribute.ParagraphStyle {
    
    public static func lineSpacing(_ value: CGFloat) -> Self {
        return .init(style: [.lineSpacing: value])
    }
    
    public static func paragraphSpacing(_ value: CGFloat) -> Self {
        return .init(style: [.paragraphSpacing: value])
    }
    
    public static func alignment(_ value: NSTextAlignment) -> Self {
        return .init(style: [.alignment: value])
    }
    
    public static func firstLineHeadIndent(_ value: CGFloat) -> Self {
        return .init(style: [.firstLineHeadIndent: value])
    }
    
    public static func headIndent(_ value: CGFloat) -> Self {
        return .init(style: [.headIndent: value])
    }
    
    public static func tailIndent(_ value: CGFloat) -> Self {
        return .init(style: [.tailIndent: value])
    }
    
    public static func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        return .init(style: [.lineBreakMode: value])
    }
    
    public static func minimumLineHeight(_ value: CGFloat) -> Self {
        return .init(style: [.minimumLineHeight: value])
    }
    
    public static func maximumLineHeight(_ value: CGFloat) -> Self {
        return .init(style: [.maximumLineHeight: value])
    }
    
    public static func baseWritingDirection(_ value: NSWritingDirection) -> Self {
        return .init(style: [.baseWritingDirection: value])
    }
    
    public static func lineHeightMultiple(_ value: CGFloat) -> Self {
        return .init(style: [.lineHeightMultiple: value])
    }
    
    public static func paragraphSpacingBefore(_ value: CGFloat) -> Self {
        return .init(style: [.paragraphSpacingBefore: value])
    }
    
    public static func hyphenationFactor(_ value: Float) -> Self {
        return .init(style: [.hyphenationFactor: value])
    }
    
    public static func tabStops(_ value: [NSTextTab]) -> Self {
        return .init(style: [.tabStops: value])
    }
    
    public static func defaultTabInterval(_ value: CGFloat) -> Self {
        return .init(style: [.defaultTabInterval: value])
    }
    
    public static func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        return .init(style: [.allowsDefaultTighteningForTruncation: value])
    }
}
