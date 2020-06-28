//
//  UITextViewExtension.swift
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
private var UITextViewCurrentKey: Void?
private var UITextViewObservationKey: Void?

extension UITextView: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UITextView {

    public var text: AttributedString {
        get { base.current?.0 ?? .init(base.attributedText) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var current = base.current, current.0.isContentEqual(to: newValue) {
                current.0 = newValue
                base.current = current
                
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let string = NSMutableAttributedString(attributedString: newValue.value)
                base.attributedText.get(current.1).forEach { (range, attributes) in
                    string.setAttributes(attributes, range: range)
                }
                base.attributedText = string
                
            } else {
                base.attributedText = newValue.value
            }
            
            #if os(iOS)
            setupGestureRecognizers()
            #endif
        }
    }
    
    #if os(iOS)
    
    private func setupGestureRecognizers() {
        base.isUserInteractionEnabled = true
        base.delaysContentTouches = false
        
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        let actions: [(NSRange, AttributedString.Action)] = base.attributedText?.get(.action) ?? []
        
        Set(actions.map({ $0.1.trigger })).forEach {
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

extension UITextView {
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && (!isEditable && !isSelectable)
    }
    
    /// 当前信息
    fileprivate var current: (AttributedString, NSRange, Action)? {
        get { associated.get(&UITextViewCurrentKey) }
        set { associated.set(retain: &UITextViewCurrentKey, newValue) }
    }
    
    /// 监听
    private var observation: NSKeyValueObservation? {
        get { associated.get(&UITextViewObservationKey) }
        set { associated.set(retain: &UITextViewObservationKey, newValue) }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isActionEnabled else { return }
        guard let touch = touches.first else { return }
        guard let (range, action) = matching(touch.location(in: self)) else { return }
        let string = attributed.text
        // 设置当前范围内容
        current = (string, range, action)
        // 设置高亮样式
        var temp: [NSAttributedString.Key: Any] = [:]
        action.highlights.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        attributedText = string.value.reset(range: range) { (attributes) in
            attributes.merge(temp, uniquingKeysWith: { $1 })
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isActionEnabled else { return }
        guard let current = self.current else { return }
        self.current = nil
        attributedText = current.0.value
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard isActionEnabled else { return }
        guard let current = self.current else { return }
        self.current = nil
        attributedText = current.0.value
    }
}

fileprivate extension UITextView {
    
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
        // 获取点击坐标 并排除各种偏移
        var point = point
        point.x -= textContainerInset.left
        point.y -= textContainerInset.top
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
        guard let action = attributedText.attribute(.action, at: index, effectiveRange: &range) as? Action else {
            return nil
        }
        return (range, action)
    }
}

#endif
#endif
