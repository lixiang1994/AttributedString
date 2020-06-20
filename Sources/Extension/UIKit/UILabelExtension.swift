//
//  UILabelExtension.swift
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

#if os(iOS) || os(tvOS)

import UIKit

private var UIGestureRecognizerKey: Void?
private var UILabelCurrentKey: Void?

extension UILabel: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UILabel {
    
    public var text: AttributedString? {
        get { AttributedString(base.attributedText) }
        set {
            base.attributedText = nil
            // UILabel 需要先将attributedText置为空 才能拿到真实的默认字体与对齐方式等
            base.attributedText = AttributedString(
                newValue?.value,
                .font(base.font),
                .paragraph(.alignment(base.textAlignment), .lineBreakMode(base.lineBreakMode))
            )?.value
            
            #if os(iOS)
            setupGestureRecognizers()
            #endif
        }
    }
    
    #if os(iOS)
    
    private func setupGestureRecognizers() {
        base.isUserInteractionEnabled = true
        
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        let actions = base.attributedText?.get(.action).compactMap({ $0 as? AttributedString.Action }) ?? []
        
        Set(actions.map({ $0.trigger })).forEach {
            switch $0 {
            case .click:
                let gesture = UITapGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                gesture.cancelsTouchesInView = false
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
                
            case .press:
                let gesture = UILongPressGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                gesture.cancelsTouchesInView = false
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
            }
        }
    }
    
    private(set) var gestures: [UIGestureRecognizer] {
        get { base.associated.get(&UIGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &UIGestureRecognizerKey, newValue) }
    }
    
    #endif
}

#if os(iOS)

extension UILabel {
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && !(adjustsFontSizeToFitWidth && numberOfLines == 1)
    }
    
    /// 当前信息
    private var current: (AttributedString, NSRange, Action)? {
        get { associated.get(&UILabelCurrentKey) }
        set { associated.set(retain: &UILabelCurrentKey, newValue) }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isActionEnabled else { return }
        guard let touch = touches.first else { return }
        guard let (range, action) = matching(touch.location(in: self)) else { return }
        // 备份原始内容
        current = (attributed.text!, range, action)
        // 设置高亮样式
        var temp: [NSAttributedString.Key: Any] = [:]
        action.highlights.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        self.attributedText = attributedText?.reset(range: range) { (attributes) in
            attributes.merge(temp, uniquingKeysWith: { $1 })
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isActionEnabled else { return }
        guard let current = self.current else { return }
        attributedText = current.0.value
        self.current = nil
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard isActionEnabled else { return }
        guard let current = self.current else { return }
        attributedText = current.0.value
        self.current = nil
    }
}

fileprivate extension UILabel {
    
    typealias Action = AttributedString.Action
    
    @objc
    func attributedAction(_ sender: UIGestureRecognizer) {
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
        guard let attributedString = AttributedString(attributedText) else { return nil }
        
        // 构建同步Label设置的TextKit
        let textStorage = NSTextStorage(attributedString: attributedString.value)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = numberOfLines
        
        // 获取文本所占高度
        let height = layoutManager.usedRect(for: textContainer).height
        
        // 获取点击坐标 并排除各种偏移
        var point = point
        point.y -= (bounds.height - height) / 2
        
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

#endif
