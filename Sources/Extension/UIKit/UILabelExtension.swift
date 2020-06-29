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
private var UILabelObservationKey: Void?

extension UILabel: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UILabel {
    
    public var text: AttributedString? {
        get { base.current?.0 ?? AttributedString(base.attributedText) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var current = base.current, current.0.isContentEqual(to: newValue) {
                guard let new = newValue else {
                    base.current = nil
                    return
                }
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: new.value)
                base.attributedText?.get(current.1).forEach { (range, attributes) in
                    temp.setAttributes(attributes, range: range)
                }
                // UILabel 需要先将attributedText置为空 才能拿到真实的默认字体与对齐方式等
                base.attributedText = nil
                var string = AttributedString(
                    new,
                    .font(base.font),
                    .paragraph(.alignment(base.textAlignment))
                )
                #if os(iOS)
                // 处理监听事件 根据设置插入Action
                setupObservation(&string)
                #endif
                current.0 = string
                base.current = current
                base.attributedText = temp
                
            } else {
                base.current = nil
                base.attributedText = nil
                // UILabel 需要先将attributedText置为空 才能拿到真实的默认字体与对齐方式等
                var string = AttributedString(
                    newValue?.value,
                    .font(base.font),
                    .paragraph(.alignment(base.textAlignment))
                )
                #if os(iOS)
                // 处理监听事件 根据设置插入Action
                setupObservation(&string)
                #endif
                base.attributedText = string?.value
            }
            
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
        
        let actions: [(NSRange, AttributedString.Action)] = text?.value.get(.action) ?? []
        
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

extension AttributedStringWrapper where Base: UILabel {
    
    /// 设置监听
    private func setupObservation(_ string: inout AttributedString?) {
        guard var temp = string else {
            return
        }
        // 消除可选类型 设置监听
        setupObservation(&temp)
        string = temp
    }
    
    /// 设置监听
    private func setupObservation(_ string: inout AttributedString) {
        guard let observation = base.observation else {
            return
        }
        // 匹配监听的类型
        let mached = string.matching(.init(observation.keys))
        mached.forEach { (range, type, result) in
            guard let value = observation[type] else { return }
            // 为监听添加Action 如果已存在 则不再添加
            string.add(range: range, action: .init(.click, highlights: value.0, with: { _ in value.1(result) }))
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
    public func observe(_ checkings: [Checking] = .all, highlights: [Highlight] = .defalut, with callback: @escaping (Checking.Result) -> Void) {
        var observation = base.observation ?? [:]
        checkings.forEach { observation[$0] = (highlights, callback) }
        base.observation = observation
    }
    
    /// 移除监听
    /// - Parameter checking: 检查类型
    public func remove(checking: Checking) {
        base.observation?.removeValue(forKey: checking)
    }
}

#endif

#if os(iOS)

extension UILabel {
    
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Observation = [Checking: ([Highlight], (Checking.Result) -> Void)]
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && !(adjustsFontSizeToFitWidth && numberOfLines == 1)
    }
    
    /// 当前信息
    fileprivate var current: (AttributedString, NSRange, Action)? {
        get { associated.get(&UILabelCurrentKey) }
        set { associated.set(retain: &UILabelCurrentKey, newValue) }
    }
    /// 监听
    fileprivate var observation: Observation? {
        get { associated.get(&UILabelObservationKey) }
        set { associated.set(retain: &UILabelObservationKey, newValue) }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isActionEnabled else { return }
        guard let string = attributed.text else { return }
        guard let touch = touches.first else { return }
        guard let (range, action) = matching(touch.location(in: self)) else { return }
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
        
//        subviews.forEach({ $0.removeFromSuperview() })
//        let view = DebugView(frame: bounds)
//        view.draw = { layoutManager.drawGlyphs(forGlyphRange: .init(location: 0, length: textStorage.length), at: .zero) }
//        addSubview(view)
        
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
        guard let action = textStorage.attribute(.action, at: index, effectiveRange: &range) as? Action else {
            return nil
        }
        return (range, action)
    }
}

fileprivate class DebugView: UIView {
    var draw: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.draw?()
    }
}

#endif
#endif
