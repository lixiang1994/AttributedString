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
private var UITextViewCheckingsKey: Void?
private var UITextViewObservationsKey: Void?

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
        
            observations = [:]
        
            do {
                for view in base.subviews where view is WrapperView {
                    view.removeFromSuperview()
                }
                let attachments: [NSRange: AttributedString.ViewAttachment] = newValue.value.get(.attachment)
                
                let layoutManager = base.layoutManager
                let textContainer = base.textContainer
                let textContainerInset = base.textContainerInset
                var temp : [NSRange: WrapperView] = [:]
                for (range, attachment) in attachments {
                    let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                    var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                    rect.origin.x += textContainerInset.left
                    rect.origin.y += textContainerInset.top
                    let view = WrapperView(frame: rect)
                    view.backgroundColor = .red
                    base.addSubview(view)
                    attachment.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view.addSubview(attachment.view)
                    temp[range] = view
                }
                
                observations["bounds"] = base.observe(\.bounds, options: [.new, .old]) { (object, changed) in
                    guard changed.newValue?.size != changed.oldValue?.size else {
                        return
                    }
                    
                    for (range, view) in temp {
                        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                        var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                        rect.origin.x += textContainerInset.left
                        rect.origin.y += textContainerInset.top
                        view.frame = rect
                    }
                }
                observations["attributedText"] = base.observe(\.attributedText, options: [.new, .old]) { (object, changed) in
                    guard changed.newValue != changed.oldValue else {
                        return
                    }
                    
                    for (range, view) in temp {
                        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                        var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                        rect.origin.x += textContainerInset.left
                        rect.origin.y += textContainerInset.top
                        view.frame = rect
                    }
                }
            }
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
    
    private(set) var observations: [String: NSKeyValueObservation] {
        get { base.associated.get(&UITextViewObservationsKey) ?? [:] }
        set { base.associated.set(retain: &UITextViewObservationsKey, newValue) }
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
        let checkings = base.checkings
        let temp = checkings.keys + (actions.isEmpty ? [] : [.action])
        string.matching(temp).forEach { (range, checking) in
            let (type, result) = checking
            switch result {
            case .action(let result):
                guard var action = actions[range] else { return }
                action.handle = {
                    action.callback(result)
                    checkings[type]?.1(.action(result))
                }
                base.actions[range] = action
                
            default:
                guard let value = checkings[type] else { return }
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
        var temp = base.checkings
        checkings.forEach { temp[$0] = (highlights, callback) }
        base.checkings = temp
    }
    
    /// 移除监听
    /// - Parameter checking: 检查类型
    public func remove(checking: Checking) {
        base.checkings.removeValue(forKey: checking)
    }
}

#endif

#if os(iOS)

extension UITextView {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Checkings = [Checking: ([Highlight], (Checking.Result) -> Void)]
    
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
    fileprivate var checkings: Checkings {
        get { associated.get(&UITextViewCheckingsKey) ?? [:] }
        set { associated.set(retain: &UITextViewCheckingsKey, newValue) }
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
        guard let action = touched?.2 else { return }
        guard action.trigger.matching(sender) else { return }
        // 点击 回调
        action.handle?()
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

fileprivate class WrapperView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
#endif
