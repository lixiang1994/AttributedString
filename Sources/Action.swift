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

#if !os(watchOS)

@available(iOS 9.0, *)
extension AttributedString {
    
    public struct Action {
        public let range: NSRange
        public let content: Content
    }
}

@available(iOS 9.0, *)
extension AttributedString.Action {
    
    public enum Content {
        case string(NSAttributedString)
        case attachment(NSTextAttachment)
    }
}

@available(iOS 9.0, *)
extension AttributedStringInterpolation.Attribute {
    
    public typealias Action = AttributedString.Action
    
    public static func action(_ value: @escaping () -> Void) -> Self {
        return action { _ in value() }
    }
    
    public static func action(_ value: @escaping (Action) -> Void) -> Self {
        return .init(attributes: [.action: value])
    }
}

@available(iOS 9.0, *)
extension AttributedStringInterpolation {
    
    public typealias Action = AttributedString.Action
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, action: @escaping () -> Void) {
        let attributedString = AttributedString(.init(attachment: value))
        self.value.append(AttributedString(attributedString, .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, action: @escaping () -> Void) {
        let attributedString = AttributedString(.init(attachment: value.value))
        self.value.append(AttributedString(attributedString, .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment, action: @escaping (Action) -> Void) {
        let attributedString = AttributedString(.init(attachment: value))
        self.value.append(AttributedString(attributedString, .action(action)).value)
    }
    
    public mutating func appendInterpolation(_ value: Attachment, action: @escaping (Action) -> Void) {
        let attributedString = AttributedString(.init(attachment: value.value))
        self.value.append(AttributedString(attributedString, .action(action)).value)
    }
}

extension AttributedString {
    
    public typealias Attachment = AttributedStringInterpolation.Attachment
    public typealias ImageTextAttachment = AttributedStringInterpolation.ImageTextAttachment
    
    public init<T: NSTextAttachment>(_ attachment: T, action: @escaping (Action) -> Void) {
        self.value = AttributedString(.init(attachment: attachment), .action(action)).value
    }
    
    public init(_ attachment: Attachment, action: @escaping (Action) -> Void) {
        self.value = AttributedString(attachment.value, action: action).value
    }
}

#endif
