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
#else
import UIKit
#endif

#if os(iOS)

extension AttributedString {
    
    public struct Action {
        public let range: NSRange
        public let content: Content
    }
}

extension AttributedString.Action {
    
    public enum Content {
        case string(NSAttributedString)
        case attachment(NSTextAttachment)
    }
}

extension AttributedString.Attribute {
    
    public typealias Action = AttributedString.Action
    
    public static func action(_ value: @escaping () -> Void) -> Self {
        return action { _ in value() }
    }
    
    public static func action(_ value: @escaping (Action) -> Void) -> Self {
        return .init(attributes: [.action: value])
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
