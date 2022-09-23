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

extension ASAttributedString {
    
    public enum Attachment {
        case image(ASImage, bounds: CGRect)
        case data(Data, type: String)
        case file(FileWrapper)
        case attachment(NSTextAttachment)
        
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
                
            case let .attachment(value):
                return value
            }
        }
    }
    
    public class ImageAttachment: NSTextAttachment {
       
        public typealias Style = Attachment.Style
        
        public let style: Style
        
        public static func image(_ image: ASImage, _ style: Style = .original()) -> ImageAttachment {
            return .init(image, style)
        }
        
        init(_ image: ASImage?, _ style: Style = .original()) {
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
                let ratio = image.size.width / image.size.height
                let width = min(lineFrag.height * ratio, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .original:
                let ratio = image.size.width / image.size.height
                let width = min(image.size.width, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .custom(let size):
                return .init(point(size), size)
            }
        }
    }
    
    #if os(iOS)
    
    public class AsyncImageAttachment: ImageAttachment {
        
        public static var Loader: AsyncImageAttachmentLoader.Type = AsyncImageAttachmentURLSessionLoader.self
        
        public let url: URL?
        public let placeholder: ASImage?
        
        private weak var textContainer: NSTextContainer?
        
        private let loader: AsyncImageAttachmentLoader
        
        /// Remote Image   (Only  support UITextView)
        /// - Parameters:
        ///   - url: 图片链接
        ///   - placeholder: 占位图
        /// - Returns: 异步图片附件
        public static func image(_ url: URL?, placeholder: ASImage? = nil, _ style: Style = .original()) -> AsyncImageAttachment {
            return .init(url, placeholder, style)
        }
        
        init(_ url: URL?, _ placeholder: ASImage?, _ style: Style = .original()) {
            self.url = url
            self.placeholder = placeholder
            self.loader = AsyncImageAttachment.Loader.init()
            super.init(placeholder, style)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func loadImage() {
            guard let url = url, placeholder == image, !loader.isLoading else {
                return
            }
            
            loader.loadImage(with: url) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let image):
                    self.image = image
                    self.textContainer?.layoutManager?.setNeedsLayout(forAttachment: self)
                    
                case .failure(let error):
                    print(error.localizedDescription as Any)
                }
            }
        }
        
        public override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> ASImage? {
            self.textContainer = textContainer
            if image == placeholder {
                loadImage()
            }
            return image
        }
        
        deinit {
            loader.cancel()
        }
    }
    
    public class ViewAttachment: NSTextAttachment {
        
        public typealias Style = Attachment.Style
        
        public let view: UIView
        public let style: Style
        
        /// Custom View  (Only  support UITextView)
        /// - Parameter view: 视图
        /// - Returns: 视图附件
        public static func view(_ view: UIView, _ style: Style = .original()) -> ViewAttachment {
            return .init(view, with: style)
        }
        
        init(_ view: UIView, with style: Style = .original()) {
            self.view = view
            self.style = style
            super.init(data: nil, ofType: nil)
            self.image = ASImage()
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
            
            view.layoutIfNeeded()
            
            switch style.mode {
            case .proposed:
                let ratio = view.bounds.width / view.bounds.height
                let width = min(lineFrag.height * ratio, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .original:
                let ratio = view.bounds.width / view.bounds.height
                let width = min(view.bounds.width, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .custom(let size):
                return .init(point(size), size)
            }
        }
    }
    
    #endif
}

extension ASAttributedString.Attachment {
    
    /// 对齐
    public enum Alignment {
        case center // Visually centered
        
        case origin // Baseline
        
        case offset(CGPoint)
    }
    
    public struct Style {
        
        enum Mode {
            case proposed
            case original
            case custom(CGSize)
        }
        
        let mode: Mode
        let alignment: Alignment
        
        /// 建议的大小 (一般为当前行的高度)
        /// - Parameter alignment: 对齐方式
        public static func proposed(_ alignment: Alignment = .origin) -> Style {
            return .init(mode: .proposed, alignment: alignment)
        }
        
        /// 原始的大小 (但会限制最大宽度不超过单行最大宽度, 如果超过则会使用单行最大宽度 并等比例缩放内容)
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

extension ASAttributedStringInterpolation {
    
    public typealias Attachment = ASAttributedString.Attachment
    public typealias ImageAttachment = ASAttributedString.ImageAttachment
    
    public mutating func appendInterpolation(_ value: Attachment) {
        self.value.append(.init(attachment: value.value))
    }
    
    public mutating func appendInterpolation(_ value: ImageAttachment) {
        self.value.append(.init(attachment: value))
    }
    
    #if os(iOS)
    
    public typealias AsyncImageAttachment = ASAttributedString.AsyncImageAttachment
    
    public mutating func appendInterpolation(_ value: AsyncImageAttachment) {
        self.value.append(.init(attachment: value))
    }
    
    public typealias ViewAttachment = ASAttributedString.ViewAttachment
    
    public mutating func appendInterpolation(_ value: ViewAttachment) {
        self.value.append(.init(attachment: value))
    }
    
    #endif
}

extension ASAttributedString {
    
    public init(_ attachment: Attachment) {
        self.value = .init(attachment: attachment.value)
    }
    
    public init(_ attachment: ImageAttachment) {
        self.value = .init(attachment: attachment)
    }
    
    #if os(iOS)
    
    public init(_ attachment: AsyncImageAttachment) {
        self.value = .init(attachment: attachment)
    }
    
    public init(_ attachment: ViewAttachment) {
        self.value = .init(attachment: attachment)
    }
    
    #endif
}

fileprivate extension ASAttributedString.Attachment.Alignment {
    
    /// 计算坐标
    /// - Parameters:
    ///   - size: 大小
    ///   - lineHeight: 行高
    /// - Returns: 位置坐标
    func point(_ size: CGSize, with lineHeight: CGFloat) -> CGPoint {
        var font = ASFont.systemFont(ofSize: 18)
        let fontSize = font.pointSize / (abs(font.descender) + abs(font.ascender)) * lineHeight
        font = .systemFont(ofSize: fontSize)
        
        switch self {
        case .origin:
            return .init(0, font.descender)
            
        case .center:
            return .init(0, (font.capHeight - size.height) / 2)
            
        case .offset(let value):
            return value
        }
    }
}

extension NSLayoutManager {
    
    /// 确定附件字符范围
    private func rangesForAttachment(attachment: NSTextAttachment) -> [NSRange]? {
        guard let attributedString = self.textStorage else {
            return nil
        }
        
        // 查找附件范围
        let range = NSRange(location: 0, length: attributedString.length)
        
        var refreshRanges = [NSRange]()
        
        attributedString.enumerateAttribute(.attachment, in: range, options: []) {
            (value, effectiveRange, nil) in
            guard
                let foundAttachment = value as? NSTextAttachment,
                foundAttachment == attachment else {
                return
            }
            
            refreshRanges.append(effectiveRange)
        }
        
        if refreshRanges.count == 0 {
            return nil
        }
        
        return refreshRanges
    }
    
    /// 触发附件刷新布局
    func setNeedsLayout(forAttachment attachment: NSTextAttachment) {
        guard let ranges = rangesForAttachment(attachment: attachment) else {
            return
        }
        
        // 设置范围显示和布局无效 触发刷新
        for range in ranges.reversed() {
            invalidateLayout(forCharacterRange: range, actualCharacterRange: nil)
            invalidateDisplay(forCharacterRange: range)
        }
    }
    
    /// 触发附件刷新显示
    func setNeedsDisplay(forAttachment attachment: NSTextAttachment) {
        guard let ranges = rangesForAttachment(attachment: attachment) else {
            return
        }
        
        // 设置范围显示无效 触发刷新
        for range in ranges.reversed() {
            invalidateDisplay(forCharacterRange: range)
        }
    }
}

#endif

#if os(iOS)

public protocol AsyncImageAttachmentLoader: NSObject {
    /// 是否加载中
    var isLoading: Bool { get }
    
    /// 加载远程图片资源
    /// - Parameters:
    ///   - url: 链接
    ///   - completion: 完成回调
    func loadImage(with url: URL, completion: @escaping (Swift.Result<ASImage, Swift.Error>) -> Void)
    /// 取消加载
    func cancel()
}

public class AsyncImageAttachmentURLSessionLoader: NSObject, AsyncImageAttachmentLoader {
    
    private var downloadTask: URLSessionDataTask?
    
    public var isLoading: Bool {
        return downloadTask != nil
    }
    
    public func loadImage(with url: URL, completion: @escaping (Result<ASImage, Error>) -> Void) {
        downloadTask = URLSession.shared.dataTask(with: url) {
            [weak self] (data, response, error) in
            guard let self = self else { return }
            self.downloadTask = nil
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NSError(domain: "Data is empty", code: -1)))
                }
                return
            }
            guard let image = ASImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Unable to create image", code: -2)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        downloadTask?.resume()
    }
    
    public func cancel() {
        downloadTask?.cancel()
        downloadTask = nil
    }
}

#endif
