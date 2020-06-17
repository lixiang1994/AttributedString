//
//  Action.swift
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

#if os(macOS)
import AppKit
public typealias GestureRecognizer = NSGestureRecognizer
#else
import UIKit
public typealias GestureRecognizer = UIGestureRecognizer
#endif

#if os(iOS) || os(macOS)

extension AttributedString {
    
    public struct Action {
        public let range: NSRange
        public let content: Content
    }
     
    public struct Highlight {
        let attributes: [NSAttributedString.Key: Any]
    }
    
    struct ActionModel {
        
        enum Trigger {
            /// 单击
            case click
            /// 按住
            case press
            /// 自定义手势
            case gesture(GestureRecognizer)
        }
        
        /// 触发类型
        let trigger: Trigger
        /// 高亮属性
        let highlights: [Highlight]
        /// 触发回调
        let callback: (Action) -> Void
        
        init(_ trigger: Trigger = .click, highlights: [Highlight] = .defalut, with callback: @escaping (Action) -> Void) {
            self.trigger = trigger
            self.highlights = highlights
            self.callback = callback
        }
    }
}

extension Array where Element == AttributedString.Highlight {
    
    static let defalut: [AttributedString.Highlight] = [.color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)), .underline(.single)]
}

extension AttributedString.Action {
    
    public enum Content {
        case string(NSAttributedString)
        case attachment(NSTextAttachment)
    }
}

extension AttributedString.Attribute {
    
    public typealias Highlight = AttributedString.Highlight
    public typealias Action = AttributedString.Action
    typealias ActionModel = AttributedString.ActionModel
    
    public static func action(_ value: @escaping () -> Void) -> Self {
        return action { _ in value() }
    }
    
    public static func action(_ value: @escaping (Action) -> Void) -> Self {
        return .init(attributes: [.action: ActionModel(with: value)])
    }
    
    public static func action(_ highlights: [Highlight], _ closure: @escaping (Action) -> Void) -> Self {
        return .init(attributes: [.action: ActionModel(highlights: highlights, with: closure)])
    }
}

extension AttributedString {
    
    public init<T: NSTextAttachment>(_ attachment: T, action: @escaping () -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(action)).value
    }
    
    public init(_ attachment: ImageTextAttachment, action: @escaping () -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(action)).value
    }
    
    public init(_ attachment: Attachment, action: @escaping () -> Void) {
        self.value = AttributedString(attachment.value, action: action).value
    }
    
    public init<T: NSTextAttachment>(_ attachment: T, action: @escaping (Action) -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(action)).value
    }
    
    public init(_ attachment: ImageTextAttachment, action: @escaping (Action) -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(action)).value
    }
    
    public init(_ attachment: Attachment, action: @escaping (Action) -> Void) {
        self.value = AttributedString(attachment.value, action: action).value
    }
}

extension AttributedStringInterpolation {
    
    public typealias Action = AttributedString.Action
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, action: @escaping () -> Void) {
        self.value.append(AttributedString(.init(attachment: value), .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, action: @escaping () -> Void) {
        self.value.append(AttributedString(.init(attachment: value.value), .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, action: @escaping (Action) -> Void) {
        self.value.append(AttributedString(.init(attachment: value), .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, action: @escaping (Action) -> Void) {
        self.value.append(AttributedString(.init(attachment: value.value), .action(action)).value)
    }
}

extension AttributedString.Highlight {
    
    public static func color(_ value: Color) -> Self {
        return .init(attributes: [.foregroundColor: value])
    }
    
    public static func background(_ value: Color) -> Self {
        return .init(attributes: [.backgroundColor: value])
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
    
    public static func shadow(_ value: NSShadow) -> Self {
        return .init(attributes: [.shadow: value])
    }
    
    public static func stroke(_ width: CGFloat = 0, color: Color? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strokeColor] = color
        temp[.strokeWidth] = width
        return .init(attributes: temp)
    }
}

extension NSAttributedString.Key {
    
    static let action = NSAttributedString.Key("com.attributed.string.action")
}

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

#endif
