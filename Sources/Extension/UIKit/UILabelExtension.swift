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

import UIKit
import CoreText

private var UITapGestureRecognizerKey: Void?

extension UILabel: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UILabel {

    public var text: AttributedString? {
        get { AttributedString(base.attributedText) }
        set {
            base.attributedText = newValue?.value
            
            if newValue?.value.contains(.action) ?? false {
                addGestureRecognizers()
                
            } else {
                removeGestureRecognizers()
            }
        }
    }
    
    @available(iOS 9.0, *)
    private func addGestureRecognizers() {
        defer { base.isUserInteractionEnabled = true }
        guard tap == nil else { return }
        
        let gesture = UITapGestureRecognizer(target: base, action: #selector(Base.attributedTapAction))
        base.addGestureRecognizer(gesture)
        tap = gesture
    }
    
    @available(iOS 9.0, *)
    private func removeGestureRecognizers() {
        guard let gesture = tap else { return }
        base.removeGestureRecognizer(gesture)
        tap = nil
    }
    
    @available(iOS 9.0, *)
    private var tap: UITapGestureRecognizer? {
        get { base.associated.get(&UITapGestureRecognizerKey) }
        set { base.associated.set(retain: &UITapGestureRecognizerKey, newValue) }
    }
}

fileprivate extension UILabel {
    
    typealias Action = AttributedString.Action
    
    @objc
    @available(iOS 9.0, *)
    func attributedTapAction(_ sender: UITapGestureRecognizer) {
        // 处理动作
        handleAction(sender.location(in: self))
    }
    
    func handleAction(_ point: CGPoint) {
        guard let attributedText = attributedText else { return }
        // 同步Label默认样式 使用嵌入包装模式 防止原有富文本样式被覆盖
        let attributedString: AttributedString = """
        \(wrap: .embedding(.init(attributedText)), with: [.font(font), .paragraph(.alignment(textAlignment))])
        """
        
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
