//
//  AttributedStringAttachment.swift
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

#if !os(watchOS)

extension AttributedString {
    
    public enum Attachment {
        case image(Image, bounds: CGRect)
        case data(Data, type: String)
        case file(FileWrapper)
        case custom(NSTextAttachment)
        
        var value: NSTextAttachment {
            switch self {
            case let .image(image, bounds):
                let temp = NSTextAttachment()
                temp.image = image
                temp.bounds = bounds
                return temp
                
            case let .data(data, type):
                return .init(data: data, ofType: type)
                
            case let .file(wrapper):
                let temp = NSTextAttachment()
                temp.fileWrapper = wrapper
                return temp
                
            case let .custom(value):
                return value
            }
        }
    }
    
    public class ImageTextAttachment: NSTextAttachment {
       
        public struct Style {
            
            fileprivate enum Mode {
                case proposed
                case original
                case custom(CGSize)
            }
            
            /// 对齐
            public enum Alignment {
                case center // Visually centered
                
                case origin
                
                case offset(CGPoint)
            }
            
            fileprivate let mode: Mode
            fileprivate let alignment: Alignment
            
            /// 建议的大小
            /// - Parameter alignment: 对齐方式
            public static func proposed(_ alignment: Alignment = .origin) -> Style {
                return .init(mode: .proposed, alignment: alignment)
            }
            
            /// 原始的大小
            /// - Parameter alignment: 对齐方式
            public static func original(_ alignment: Alignment = .origin) -> Style {
                return .init(mode: .original, alignment: alignment)
            }
            
            /// 自定义的
            /// - Parameter alignment: 对齐
            /// - Parameter size: 大小
            public static func custom(_ alignment: Alignment = .origin, size: CGSize) -> Style {
                return .init(mode: .custom(size), alignment: alignment)
            }
        }
        
        private let style: Style
        
        public static func image(_ image: Image, _ style: Style = .original()) -> ImageTextAttachment {
            return .init(image, style)
        }
        
        init(_ image: Image, _ style: Style = .original()) {
            self.style = style
            super.init(data: nil, ofType: nil)
            self.image = image
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
            
            guard let image = image else {
                return super.attachmentBounds(
                    for: textContainer,
                    proposedLineFragment: lineFrag,
                    glyphPosition: position,
                    characterIndex: charIndex
                )
            }
            
            func point(_ size: CGSize) -> CGPoint {
                switch style.alignment {
                case .origin:
                    return .zero
                    
                case .center:
                    return .init(0, -size.height / 4.0)
                    
                case .offset(let value):
                    return value
                }
            }
            
            switch style.mode {
            case .proposed:
                let radio = image.size.width / image.size.height
                let width = min(lineFrag.height * radio, lineFrag.width)
                let height = width / radio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .original:
                let radio = image.size.width / image.size.height
                let width = min(image.size.width, lineFrag.width)
                let height = width / radio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .custom(let size):
                return .init(point(size), size)
            }
        }
    }    
}

extension AttributedStringInterpolation {
    
    public typealias Attachment = AttributedString.Attachment
    public typealias ImageTextAttachment = AttributedString.ImageTextAttachment
    
    public mutating func appendInterpolation(_ value: ImageTextAttachment) {
        self.value.append(.init(attachment: value))
    }
    
    public mutating func appendInterpolation(_ value: Attachment) {
        self.value.append(.init(attachment: value.value))
    }
}

extension AttributedString {
    
    public init(_ attachment: ImageTextAttachment) {
        self.value = .init(attachment: attachment)
    }

    public init(_ attachment: Attachment) {
        self.value = .init(attachment: attachment.value)
    }
}

#endif
