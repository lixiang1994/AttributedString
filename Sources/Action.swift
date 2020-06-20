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
typealias GestureRecognizer = NSGestureRecognizer
#elseif os(iOS)
import UIKit
typealias GestureRecognizer = UIGestureRecognizer
#elseif os(watchOS)
import WatchKit
typealias GestureRecognizer = WKGestureRecognizer
#endif

#if os(iOS) || os(macOS)

extension AttributedString {
    
    public struct Action {
        /// 触发类型
        let trigger: Trigger
        /// 高亮属性
        let highlights: [Highlight]
        /// 触发回调
        let callback: (Result) -> Void
        
        public init(_ trigger: Trigger = .click, highlights: [Highlight] = .defalut, with callback: @escaping (Result) -> Void) {
            self.trigger = trigger
            self.highlights = highlights
            self.callback = callback
        }
    }
}

public extension Array where Element == AttributedString.Action.Highlight {
    
    static var defalut: [AttributedString.Action.Highlight] = [.color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)), .underline(.single)]
    
    static let empty: [AttributedString.Action.Highlight] = []
}

extension AttributedString.Action {
    
    public enum Trigger: Hashable {
        /// 单击  default
        case click
        /// 按住
        case press
    }
    
    public struct Result {
        public let range: NSRange
        public let content: Content
    }
     
    public struct Highlight {
        let attributes: [NSAttributedString.Key: Any]
    }
}

extension AttributedString.Action.Result {
    
    public enum Content {
        case string(NSAttributedString)
        case attachment(NSTextAttachment)
    }
}

extension AttributedString.Attribute {
    
    public typealias Action = AttributedString.Action
    public typealias Trigger = Action.Trigger
    public typealias Highlight = Action.Highlight
    public typealias Result = Action.Result
    
    public static func action(_ value: @escaping () -> Void) -> Self {
        return action { _ in value() }
    }
    
    public static func action(_ value: @escaping (Result) -> Void) -> Self {
        return .init(attributes: [.action: Action(with: value)])
    }
    
    public static func action(_ trigger: Trigger, _ closure: @escaping () -> Void) -> Self {
        return .init(attributes: [.action: Action(trigger, with: { _ in closure() })])
    }
    
    public static func action(_ trigger: Trigger, _ closure: @escaping (Result) -> Void) -> Self {
        return .init(attributes: [.action: Action(trigger, with: closure)])
    }
    
    public static func action(_ highlights: [Highlight], _ closure: @escaping () -> Void) -> Self {
        return .init(attributes: [.action: Action(highlights: highlights, with: { _ in closure() })])
    }
    
    public static func action(_ highlights: [Highlight], _ closure: @escaping (Result) -> Void) -> Self {
        return .init(attributes: [.action: Action(highlights: highlights, with: closure)])
    }
    
    public static func action(_ value: Action) -> Self {
        return .init(attributes: [.action: value])
    }
}

extension AttributedString {
    
    public init(_ attachment: ImageTextAttachment, trigger: Action.Trigger = .click, action: @escaping () -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(trigger, action)).value
    }
    
    public init(_ attachment: Attachment, trigger: Action.Trigger = .click, action: @escaping () -> Void) {
        self.value = AttributedString(.init(attachment: attachment.value), .action(trigger, action)).value
    }
    
    public init(_ attachment: ImageTextAttachment, trigger: Action.Trigger = .click, action: @escaping (Action.Result) -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(trigger, action)).value
    }
    
    public init(_ attachment: Attachment, trigger: Action.Trigger = .click, action: @escaping (Action.Result) -> Void) {
        self.value = AttributedString(.init(attachment: attachment.value), .action(trigger, action)).value
    }
    
    public init(_ attachment: ImageTextAttachment, action: Action) {
        self.value = AttributedString(.init(attachment: attachment), .action(action)).value
    }
    
    public init(_ attachment: Attachment, action: Action) {
        self.value = AttributedString(.init(attachment: attachment.value), .action(action)).value
    }
}

extension AttributedStringInterpolation {
    
    public typealias Action = AttributedString.Action
    public typealias Result = Action.Result
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, trigger: Action.Trigger = .click, action: @escaping () -> Void) {
        self.value.append(AttributedString(.init(attachment: value), .action(trigger, action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, trigger: Action.Trigger = .click, action: @escaping () -> Void) {
        self.value.append(AttributedString(.init(attachment: value.value), .action(trigger, action)).value)
    }
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, trigger: Action.Trigger = .click, action: @escaping (Result) -> Void) {
        self.value.append(AttributedString(.init(attachment: value), .action(trigger, action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, trigger: Action.Trigger = .click, action: @escaping (Result) -> Void) {
        self.value.append(AttributedString(.init(attachment: value.value), .action(trigger, action)).value)
    }
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, action: Action) {
        self.value.append(AttributedString(.init(attachment: value), .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, action: Action) {
        self.value.append(AttributedString(.init(attachment: value.value), .action(action)).value)
    }
}

extension AttributedString.Action.Highlight {
    
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

extension AttributedString.Action.Trigger {

    func matching(_ gesture: GestureRecognizer) -> Bool {
        switch self {
        #if os(iOS)
        case .click where gesture is UITapGestureRecognizer:
            return gesture.state == .ended
        case .press where gesture is UILongPressGestureRecognizer:
            return gesture.state == .began
        #endif
        
        #if os(macOS)
        case .click where gesture is NSClickGestureRecognizer:
            return gesture.state == .ended
        case .press where gesture is NSPressGestureRecognizer:
            return gesture.state == .began
        #endif
        default:
            return false
        }
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
        ) { (value, range, stop) in
            guard value != nil else { return }
            result = true
            stop.pointee = true
        }
        return result
    }
    
    func get(_ name: Key) -> [Any] {
        var result: [Any] = []
        enumerateAttribute(
            name,
            in: .init(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (value, range, stop) in
            guard let value = value else { return }
            result.append(value)
        }
        return result
    }
    
    func reset(range: NSRange, attributes handle: (inout [NSAttributedString.Key: Any]) -> Void) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        enumerateAttributes(
            in: range,
            options: .longestEffectiveRangeNotRequired
        ) { (attributes, range, stop) in
            var temp = attributes
            handle(&temp)
            string.setAttributes(temp, range: range)
        }
        return string
    }
}

#endif
