//
//  NSTextFieldExtension.swift
//  AttributedString
//
//  Created by Lee on 2020/4/8.
//  Copyright © 2020 LEE. All rights reserved.
//

import AppKit

private var NSClickGestureRecognizerKey: Void?

extension NSTextField: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: NSTextField {

    public var string: AttributedString {
        get { AttributedString(base.attributedStringValue) }
        set {
            base.attributedStringValue = newValue.value
            
            #if os(macOS)
            if newValue.value.contains(.action) {
                addGestureRecognizers()
                
            } else {
                removeGestureRecognizers()
            }
            #endif
        }
    }
    
    public var placeholder: AttributedString? {
        get { AttributedString(base.placeholderAttributedString) }
        set { base.placeholderAttributedString = newValue?.value }
    }
    
    #if os(macOS)
    
    private func addGestureRecognizers() {
        guard click == nil else { return }
        let gesture = NSClickGestureRecognizer(target: base, action: #selector(Base.attributedClickAction))
        base.addGestureRecognizer(gesture)
        click = gesture
    }
    
    private func removeGestureRecognizers() {
        guard let gesture = click else { return }
        base.removeGestureRecognizer(gesture)
        click = nil
    }
    
    private var click: NSClickGestureRecognizer? {
        get { base.associated.get(&NSClickGestureRecognizerKey) }
        set { base.associated.set(retain: &NSClickGestureRecognizerKey, newValue) }
    }
    
    #endif
}

#if os(macOS)

fileprivate extension NSTextField {
    
    typealias Action = AttributedString.Action
    
    @objc
    func attributedClickAction(_ sender: NSClickGestureRecognizer) {
        guard !isEditable, !isSelectable else {
            return
        }
        
        // 处理动作
        handleAction(sender.location(in: self))
    }
    
    func handleAction(_ point: CGPoint) {
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
            return
        }
        // 获取点击的字符串范围和回调事件
        var range = NSRange()
        guard let action = attributedString.value.attribute(.action, at: index, effectiveRange: &range) as? (Action) -> Void else {
            return
        }
        let substring = attributedString.value.attributedSubstring(from: range)
        if let attachment = substring.attribute(.attachment, at: 0, effectiveRange: nil) as? NSTextAttachment {
            action(.init(range: range, content: .attachment(attachment)))
            
        } else {
            action(.init(range: range, content: .string(substring)))
        }
    }
}

#endif
