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
private var NSEventMonitorKey: Void?
private var NSTextFieldCurrentKey: Void?

extension NSTextField: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: NSTextField {

    public var string: AttributedString {
        get { AttributedString(base.attributedStringValue) }
        set {
            base.attributedStringValue = AttributedString(
                newValue.value,
                .font(base.font!),
                .paragraph(
                    .alignment(base.alignment),
                    .baseWritingDirection(base.baseWritingDirection)
                )
            ).value
            
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
            }
        }
        
        monitors.forEach { NSEvent.removeMonitor($0) }
        monitors = []
        guard base.isActionEnabled else { return }
        if let monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown, handler: { (event) -> NSEvent? in
            self.base.attributed_mouseDown(with: event)
            return event
        }) {
            monitors.append(monitor)
        }
        if let monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp, handler: { (event) -> NSEvent? in
            self.base.attributed_mouseUp(with: event)
            return event
        }) {
            monitors.append(monitor)
        }
    }
    
    private(set) var gestures: [NSGestureRecognizer] {
        get { base.associated.get(&NSGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &NSGestureRecognizerKey, newValue) }
    }
    
    private(set) var monitors: [Any] {
        get { base.associated.get(&NSEventMonitorKey) ?? [] }
        set { base.associated.set(retain: &NSEventMonitorKey, newValue) }
    }
}

extension NSTextField {
    
    typealias Action = AttributedString.Action
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && (!isEditable && !isSelectable)
    }
    
    /// 当前信息
    private var current: (AttributedString, NSRange, Action)? {
        get { associated.get(&NSTextFieldCurrentKey) }
        set { associated.set(retain: &NSTextFieldCurrentKey, newValue) }
    }
    
    @objc
    func attributed_mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        guard bounds.contains(point), window == event.window else { return }
        guard isActionEnabled else { return }
        guard let (range, action) = matching(point) else { return }
        // 备份当前信息
        current = (attributed.string, range, action)
        // 设置高亮样式
        var temp: [NSAttributedString.Key: Any] = [:]
        action.highlights.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        self.attributedStringValue = attributedStringValue.reset(range: range) { (attributes) in
            attributes.merge(temp, uniquingKeysWith: { $1 })
        }
    }
    
    @objc
    func attributed_mouseUp(with event: NSEvent) {
        guard isActionEnabled else { return }
        guard let current = self.current else { return }
        DispatchQueue.main.async {
            self.attributedStringValue = current.0.value
            self.current = nil
        }
    }
}

fileprivate extension NSTextField {
    
    @objc
    func attributedAction(_ sender: NSGestureRecognizer) {
        guard isActionEnabled else { return }
        guard let (string, range, action) = current else { return }
        guard action.trigger.matching(sender) else { return }
        
        // 点击 回调
        let substring = string.value.attributedSubstring(from: range)
        if let attachment = substring.attribute(.attachment, at: 0, effectiveRange: nil) as? NSTextAttachment {
            action.callback(.init(range: range, content: .attachment(attachment)))
            
        } else {
            action.callback(.init(range: range, content: .string(substring)))
        }
    }
    
    func matching(_ point: CGPoint) -> (NSRange, Action)? {
        let attributedString = AttributedString(attributedStringValue)
        
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
