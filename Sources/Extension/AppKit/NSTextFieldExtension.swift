//
//  NSTextFieldExtension.swift
//  AttributedString
//
//  Created by Lee on 2020/4/8.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(macOS)

import AppKit

private var NSGestureRecognizerKey: Void?

extension NSTextField: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: NSTextField {

    public var string: AttributedString {
        get { AttributedString(base.attributedStringValue) }
        set {
            base.attributedStringValue = newValue.value
            
            setupGestureRecognizers()
        }
    }
    
    public var placeholder: AttributedString? {
        get { AttributedString(base.placeholderAttributedString) }
        set { base.placeholderAttributedString = newValue?.value }
    }
    
    private func setupGestureRecognizers() {
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        let actions = base.attributedStringValue.get(.action).compactMap({ $0 as? AttributedString.Action })
        
        Set(actions.map({ $0.trigger })).forEach {
            switch $0 {
            case .click:
                let gesture = NSClickGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
                
            case .press:
                let gesture = NSPressGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
                
            case .gesture(let gesture):
                gesture.target = base
                gesture.action = #selector(Base.attributedAction)
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
            }
        }
    }
    
    private(set) var gestures: [NSGestureRecognizer] {
        get { base.associated.get(&NSGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &NSGestureRecognizerKey, newValue) }
    }
}

extension NSTextField {

    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && (!isEditable && !isSelectable)
    }
    
    private static var attributedString: AttributedString?
    
    open override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        guard isActionEnabled else { return }
        guard let touch = event.touches(matching: .began, in: self).first else { return }
        guard let (range, action) = matching(touch.location(in: self)) else { return }
        // 备份原始内容
        NSTextField.attributedString = attributed.string
        // 设置高亮样式
        var temp: [NSAttributedString.Key: Any] = [:]
        action.highlights.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        self.attributedStringValue = attributedStringValue.reset(range: range) { (attributes) in
            attributes.merge(temp, uniquingKeysWith: { $1 })
        }
    }
    
    open override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        guard isActionEnabled else { return }
        guard let attributedString = NSTextField.attributedString else { return }
        attributedStringValue = attributedString.value
        NSTextField.attributedString = nil
    }
    
    open override func beginGesture(with event: NSEvent) {
        super.beginGesture(with: event)
    }
    
    open override func endGesture(with event: NSEvent) {
        super.endGesture(with: event)
    }
}

fileprivate extension NSTextField {
    
    typealias Action = AttributedString.Action
    
    @objc
    func attributedAction(_ sender: NSGestureRecognizer) {
        guard sender.state == .ended else { return }
        guard isActionEnabled else { return }
        guard let string = NSTextField.attributedString?.value else { return }
        guard let (range, action) = matching(sender.location(in: self)) else { return }
        guard action.trigger.matching(sender) else { return }
        
        // 获取点击字符串 回调
        let substring = string.attributedSubstring(from: range)
        if let attachment = substring.attribute(.attachment, at: 0, effectiveRange: nil) as? NSTextAttachment {
            action.callback(.init(range: range, content: .attachment(attachment)))
            
        } else {
            action.callback(.init(range: range, content: .string(substring)))
        }
        
        guard let attributedString = NSTextField.attributedString else { return }
        attributedStringValue = attributedString.value
        NSTextField.attributedString = nil
    }
    
    func matching(_ point: CGPoint) -> (NSRange, Action)? {
        // 同步NSTextField默认样式 使用嵌入包装模式 防止原有富文本样式被覆盖
        let attributedString: AttributedString = """
        \(wrap: .embedding(.init(attributedStringValue)), with: [.font(font!), .paragraph(.alignment(alignment), .baseWritingDirection(baseWritingDirection))])
        """
        
        // 构建同步Label设置的TextKit
        let textStorage = NSTextStorage(attributedString: attributedString.value)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = usesSingleLineMode ? 1 : 0
        
        // 获取字形下标
        var fraction: CGFloat = 0
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: &fraction)
        // 获取字符下标
        let index = layoutManager.characterIndexForGlyph(at: glyphIndex)
        // 通过字形距离判断是否在字形范围内
        guard fraction > 0, fraction < 1 else {
            return nil
        }
        // 获取点击的字符串范围和回调事件
        var range = NSRange()
        guard let action = attributedString.value.attribute(.action, at: index, effectiveRange: &range) as? Action else {
            return nil
        }
        return (range, action)
    }
}

#endif
