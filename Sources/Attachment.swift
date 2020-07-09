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
    
    public class ImageAttachment: NSTextAttachment {
       
        public typealias Style = Attachment.Style
        
        private let style: Style
        
        public static func image(_ image: Image, _ style: Style = .original()) -> ImageAttachment {
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
                return style.alignment.point(size, with: lineFrag.height)
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
    
    #if os(iOS)
    
    public class ViewAttachment: NSTextAttachment {
        
        public typealias Style = Attachment.Style
        
        let view: UIView
        
        private let style: Style
        
        /// Custom View  (Only  support UITextView)
        /// - Parameter view: 视图
        /// - Returns: 视图附件
        public static func view(_ view: UIView, _ style: Style = .original()) -> ViewAttachment {
            return .init(view, with: style)
        }
        
        init(_ view: UIView, with style: Style = .original()) {
            view.layoutIfNeeded()
            self.view = view
            self.style = style
            super.init(data: nil, ofType: nil)
            self.image = Image()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
            guard image != nil else {
                return super.attachmentBounds(
                    for: textContainer,
                    proposedLineFragment: lineFrag,
                    glyphPosition: position,
                    characterIndex: charIndex
                )
            }
            
            func point(_ size: CGSize) -> CGPoint {
                return style.alignment.point(size, with: lineFrag.height)
            }
            
            switch style.mode {
            case .proposed:
                let radio = view.bounds.width / view.bounds.height
                let width = min(lineFrag.height * radio, lineFrag.width)
                let height = width / radio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .original:
                let radio = view.bounds.width / view.bounds.height
                let width = min(view.bounds.width, lineFrag.width)
                let height = width / radio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .custom(let size):
                return .init(point(size), size)
            }
        }
    }
    
    #endif
}

extension AttributedString.Attachment {
    
    /// 对齐
    public enum Alignment {
        case center // Visually centered
        
        case origin // Baseline
        
        case bottom // Bottom
        
        case offset(CGPoint)
    }
    
    public struct Style {
        
        enum Mode {
            case proposed
            case original
            case custom(CGSize)
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
}

extension AttributedStringInterpolation {
    
    public typealias Attachment = AttributedString.Attachment
    public typealias ImageAttachment = AttributedString.ImageAttachment
    
    public mutating func appendInterpolation(_ value: Attachment) {
        self.value.append(.init(attachment: value.value))
    }
    
    public mutating func appendInterpolation(_ value: ImageAttachment) {
        self.value.append(.init(attachment: value))
    }
    
    #if os(iOS)
    
    public typealias ViewAttachment = AttributedString.ViewAttachment
    
    public mutating func appendInterpolation(_ value: ViewAttachment) {
        self.value.append(.init(attachment: value))
    }
    
    #endif
}

extension AttributedString {
    
    public init(_ attachment: Attachment) {
        self.value = .init(attachment: attachment.value)
    }
    
    public init(_ attachment: ImageAttachment) {
        self.value = .init(attachment: attachment)
    }
    
    #if os(iOS)
    
    public init(_ attachment: ViewAttachment) {
        self.value = .init(attachment: attachment)
    }
    
    #endif
}

fileprivate extension AttributedString.Attachment.Alignment {
    
    /// 计算坐标
    /// - Parameters:
    ///   - size: 大小
    ///   - lineHeight: 行高
    /// - Returns: 位置坐标
    func point(_ size: CGSize, with lineHeight: CGFloat) -> CGPoint {
        var font = Font.systemFont(ofSize: 18)
        let fontSize = font.pointSize / (abs(font.descender) + abs(font.ascender)) * lineHeight
        font = .systemFont(ofSize: fontSize)
        
        switch self {
        case .bottom:
            return .zero
            
        case .origin:
            return .init(0, font.descender)
            
        case .center:
            // https://code-examples.net/zh-CN/q/18e57cb
            return .init(0, (font.capHeight - size.height) / 2)
            
        case .offset(let value):
            return value
        }
    }
}

#endif
