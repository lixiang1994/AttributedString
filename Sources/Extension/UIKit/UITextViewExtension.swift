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
private var UITextViewTouchedKey: Void?
private var UITextViewActionsKey: Void?
private var UITextViewObservationKey: Void?

extension UITextView: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UITextView {

    #if os(iOS)
    
    public var text: AttributedString {
        get { base.touched?.0 ?? .init(base.attributedText) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var touched = base.touched, touched.0.isContentEqual(to: newValue) {
                touched.0 = newValue
                base.touched = touched
                
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: newValue.value)
                base.attributedText.get(touched.1).forEach { (range, attributes) in
                    temp.setAttributes(attributes, range: range)
                }
                base.attributedText = temp
                
            } else {
                base.attributedText = newValue.value
            }
            
            setupActions(newValue)
            setupGestureRecognizers()
        }
    }
    
    #else
    
    public var text: AttributedString {
        get { .init(base.attributedText) }
        set { base.attributedText = newValue.value }
    }
    
    #endif
}

#if os(iOS)

extension AttributedStringWrapper where Base: UITextView {
    
    private(set) var gestures: [UIGestureRecognizer] {
        get { base.associated.get(&UIGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &UIGestureRecognizerKey, newValue) }
    }
    
    /// 设置动作
    private func setupActions(_ string: AttributedString?) {
        // 清理原有动作记录
        base.actions = [:]
        
        guard let string = string else {
            return
        }
        // 获取全部动作
        let actions: [NSRange: AttributedString.Action] = string.value.get(.action)
        // 匹配检查
        let observation = base.observation
        let checkings = observation.keys + (actions.isEmpty ? [] : [.action])
        string.matching(checkings).forEach { (range, checking) in
            let (type, result) = checking
            switch result {
            case .action(let result):
                guard var action = actions[range] else { return }
                action.handle = {
                    action.callback(result)
                    observation[type]?.1(.action(result))
                }
                base.actions[range] = action
                
            default:
                guard let value = observation[type] else { return }
                base.actions[range] = .init(.click, highlights: value.0) { _ in value.1(result) }
            }
        }
    }
    
    /// 设置手势识别
    private func setupGestureRecognizers() {
        base.isUserInteractionEnabled = true
        base.delaysContentTouches = false
        
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        Set(base.actions.values.map({ $0.trigger })).forEach {
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
    
    /// 添加监听
    /// - Parameters:
    ///   - checking: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checking: Checking, highlights: [Highlight] = .defalut, with callback: @escaping (Checking.Result) -> Void) {
        observe([checking], highlights: highlights, with: callback)
    }
    
    /// 添加监听
    /// - Parameters:
    ///   - checkings: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checkings: [Checking] = .defalut, highlights: [Highlight] = .defalut, with callback: @escaping (Checking.Result) -> Void) {
        var observation = base.observation
        checkings.forEach { observation[$0] = (highlights, callback) }
        base.observation = observation
    }
    
    /// 移除监听
    /// - Parameter checking: 检查类型
    public func remove(checking: Checking) {
        base.observation.removeValue(forKey: checking)
    }
}

#endif

#if os(iOS)

extension UITextView {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Observation = [Checking: ([Highlight], (Checking.Result) -> Void)]
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !actions.isEmpty && (!isEditable && !isSelectable)
    }
    
    /// 触摸信息
    fileprivate var touched: (AttributedString, NSRange, Action)? {
        get { associated.get(&UITextViewTouchedKey) }
        set { associated.set(retain: &UITextViewTouchedKey, newValue) }
    }
    /// 全部动作
    fileprivate var actions: [NSRange: Action] {
        get { associated.get(&UITextViewActionsKey) ?? [:] }
        set { associated.set(retain: &UITextViewActionsKey, newValue) }
    }
    /// 监听信息
    fileprivate var observation: Observation {
        get { associated.get(&UITextViewObservationKey) ?? [:] }
        set { associated.set(retain: &UITextViewObservationKey, newValue) }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isActionEnabled else { return }
        guard let touch = touches.first else { return }
        guard let (range, action) = matching(touch.location(in: self)) else { return }
        let string = attributed.text
        // 设置触摸范围内容
        touched = (string, range, action)
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
        guard let touched = self.touched else { return }
        self.touched = nil
        attributedText = touched.0.value
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard isActionEnabled else { return }
        guard let touched = self.touched else { return }
        self.touched = nil
        attributedText = touched.0.value
    }
}

fileprivate extension UITextView {
    
    @objc
    func attributedAction(_ sender: UIGestureRecognizer) {
        guard isActionEnabled else { return }
        guard let (string, range, action) = touched else { return }
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
        guard
            let range = actions.keys.first(where: { $0.contains(index) }),
            let action = actions[range] else {
            return nil
        }
        return (range, action)
    }
}

#endif
#endif
