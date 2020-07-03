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
private var UILabelTouchedKey: Void?
private var UILabelActionsKey: Void?
private var UILabelObservationKey: Void?

extension UILabel: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UILabel {
    
    public var text: AttributedString? {
        get { base.touched?.0 ?? AttributedString(base.attributedText) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var touched = base.touched, touched.0.isContentEqual(to: newValue) {
                guard let new = newValue else {
                    base.touched = nil
                    return
                }
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: new.value)
                base.attributedText?.get(touched.1).forEach { (range, attributes) in
                    temp.setAttributes(attributes, range: range)
                }
                // UILabel 需要先将attributedText置为空 才能拿到真实的默认字体与对齐方式等
                base.attributedText = nil
                let string = AttributedString(
                    new,
                    .font(base.font),
                    .paragraph(.alignment(base.textAlignment))
                )
                touched.0 = string
                base.touched = touched
                base.attributedText = temp
                
                #if os(iOS)
                setupActions(string)
                setupGestureRecognizers()
                #endif
                
            } else {
                base.touched = nil
                base.attributedText = nil
                // UILabel 需要先将attributedText置为空 才能拿到真实的默认字体与对齐方式等
                let string = AttributedString(
                    newValue?.value,
                    .font(base.font),
                    .paragraph(.alignment(base.textAlignment))
                )
                base.attributedText = string?.value
                
                #if os(iOS)
                setupActions(string)
                setupGestureRecognizers()
                #endif
            }
        }
    }
    
    #if os(iOS)
    
    private func setupGestureRecognizers() {
        base.isUserInteractionEnabled = true
        
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
    
    private(set) var gestures: [UIGestureRecognizer] {
        get { base.associated.get(&UIGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &UIGestureRecognizerKey, newValue) }
    }
    
    #endif
}

#if os(iOS)

extension AttributedStringWrapper where Base: UILabel {
    
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
        let checking = observation.keys + (actions.isEmpty ? [] : [.action])
        string.matching(checking).forEach { (range, type, result) in
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
        base.observation.removeValue(forKey: checking)
    }
}

#endif

#if os(iOS)

extension UILabel {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Observation = [Checking: ([Highlight], (Checking.Result) -> Void)]
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !actions.isEmpty && !(adjustsFontSizeToFitWidth && numberOfLines == 1)
    }
    
    /// 当前触摸
    fileprivate var touched: (AttributedString, NSRange, Action)? {
        get { associated.get(&UILabelTouchedKey) }
        set { associated.set(retain: &UILabelTouchedKey, newValue) }
    }
    /// 全部动作
    fileprivate var actions: [NSRange: Action] {
        get { associated.get(&UILabelActionsKey) ?? [:] }
        set { associated.set(retain: &UILabelActionsKey, newValue) }
    }
    /// 监听信息
    fileprivate var observation: Observation {
        get { associated.get(&UILabelObservationKey) ?? [:] }
        set { associated.set(retain: &UILabelObservationKey, newValue) }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isActionEnabled else { return }
        guard let string = attributed.text else { return }
        guard let touch = touches.first else { return }
        guard let (range, action) = matching(touch.location(in: self)) else { return }
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

fileprivate extension UILabel {
    
    @objc
    func attributedAction(_ sender: UIGestureRecognizer) {
        guard isActionEnabled else { return }
        guard let action = touched?.2 else { return }
        guard action.trigger.matching(sender) else { return }
        // 点击 回调
        action.handle?()
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
        guard
            let range = actions.keys.first(where: { $0.contains(index) }),
            let action = actions[range] else {
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
