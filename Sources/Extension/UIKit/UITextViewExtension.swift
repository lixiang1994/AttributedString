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

import UIKit

private var UITapGestureRecognizerKey: Void?

extension UITextView: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UITextView {

    public var text: AttributedString {
        get { .init(base.attributedText) }
        set {
            base.attributedText = newValue.value
            
            #if os(iOS)
            if newValue.value.contains(.action) {
                addGestureRecognizers()
                
            } else {
                removeGestureRecognizers()
            }
            #endif
        }
    }
    
    #if os(iOS)
    
    private func addGestureRecognizers() {
        guard tap == nil else { return }
        
        let gesture = UITapGestureRecognizer(target: base, action: #selector(Base.attributedTapAction))
        base.addGestureRecognizer(gesture)
        tap = gesture
    }
    
    private func removeGestureRecognizers() {
        guard let gesture = tap else { return }
        base.removeGestureRecognizer(gesture)
        tap = nil
    }
    
    private var tap: UITapGestureRecognizer? {
        get { base.associated.get(&UITapGestureRecognizerKey) }
        set { base.associated.set(retain: &UITapGestureRecognizerKey, newValue) }
    }
    
    #endif
}

#if os(iOS)

fileprivate extension UITextView {
    
    typealias Action = AttributedString.Action
    
    @objc
    func attributedTapAction(_ sender: UITapGestureRecognizer) {
        guard !isEditable, !isSelectable else {
            return
        }
        
        // 处理动作
        handleAction(sender.location(in: self))
    }
    
    func handleAction(_ point: CGPoint) {
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
            return
        }
        // 获取点击的字符串范围和回调事件
        var range = NSRange()
        guard let action = attributedText.attribute(.action, at: index, effectiveRange: &range) as? (Action) -> Void else {
            return
        }
        let substring = attributedText.attributedSubstring(from: range)
        
        if let attachment = substring.attribute(.attachment, at: 0, effectiveRange: nil) as? NSTextAttachment {
            action(.init(range: range, content: .attachment(attachment)))
            
        } else {
            action(.init(range: range, content: .string(substring)))
        }
    }
}

#endif
