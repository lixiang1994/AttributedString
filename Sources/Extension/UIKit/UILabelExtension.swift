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
private var UILabelCheckingsKey: Void?

extension UILabel: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UILabel {
    
    #if os(iOS)
    
    public var text: AttributedString? {
        get { base.touched?.0 ?? AttributedString(base.attributedText) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var touched = base.touched, touched.0.isContentEqual(to: newValue) {
                guard let string = newValue else {
                    base.touched = nil
                    return
                }
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: string.value)
                base.attributedText?.get(touched.1).forEach { (range, attributes) in
                    temp.setAttributes(attributes, range: range)
                }
                base.attributedText = temp
                
                touched.0 = string
                base.touched = touched
                
                setupActions(string)
                setupGestureRecognizers()
                
            } else {
                base.touched = nil
                base.attributedText = newValue?.value
                
                setupActions(newValue)
                setupGestureRecognizers()
            }
        }
    }
    
    #else
    
    public var text: AttributedString? {
        get { AttributedString(base.attributedText) }
        set { base.attributedText = newValue?.value }
    }
    
    #endif
}

#if os(iOS)

extension AttributedStringWrapper where Base: UILabel {
    
    /// 添加监听
    /// - Parameters:
    ///   - checking: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checking: Checking,
                        highlights: [Highlight] = .defalut,
                        with callback: @escaping (Checking.Result) -> Void) {
        observe([checking], highlights: highlights, with: callback)
    }
    /// 添加监听
    /// - Parameters:
    ///   - checkings: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checkings: [Checking] = .defalut,
                        highlights: [Highlight] = .defalut,
                        with callback: @escaping (Checking.Result) -> Void) {
        var temp = base.checkings
        checkings.forEach { temp[$0] = (highlights, { callback($0.1) }) }
        base.checkings = temp
    }
    /// 添加监听
    /// - Parameters:
    ///   - checkings: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checkings: [Checking] = .defalut,
                        highlights: [Highlight] = .defalut,
                        with callback: @escaping (NSRange, Checking.Result) -> Void) {
        var temp = base.checkings
        checkings.forEach { temp[$0] = (highlights, { callback($0.0, $0.1) }) }
        base.checkings = temp
    }
    
    /// 移除监听
    /// - Parameter checking: 检查类型
    public func remove(checking: Checking) {
        base.checkings.removeValue(forKey: checking)
    }
    /// 移除监听
    /// - Parameter checkings: 检查类型
    public func remove(checkings: [Checking]) {
        checkings.forEach { base.checkings.removeValue(forKey: $0) }
    }
}

extension AttributedStringWrapper where Base: UILabel {
    
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
        let checkings = base.checkings
        let temp = checkings.keys + (actions.isEmpty ? [] : [.action])
        string.matching(temp).forEach { (range, checking) in
            let (type, result) = checking
            switch result {
            case .action(let result):
                guard var action = actions[range] else { return }
                action.handle = {
                    action.callback(.init(range: range, content: result))
                    checkings[type]?.1((range, .action(result)))
                }
                base.actions[range] = action
                
            default:
                guard let value = checkings[type] else { return }
                var action = Action(.click, highlights: value.0)
                action.handle = {
                    value.1((range, result))
                }
                base.actions[range] = action
            }
        }
    }
    
    /// 设置手势识别
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
}

#endif

#if os(iOS)

extension UILabel {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Checkings = [Checking: ([Highlight], ((NSRange, Checking.Result)) -> Void)]
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !actions.isEmpty
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
    fileprivate var checkings: Checkings {
        get { associated.get(&UILabelCheckingsKey) ?? [:] }
        set { associated.set(retain: &UILabelCheckingsKey, newValue) }
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

private extension UILabel {
    // Runtime Headers
    // https://github.com/nst/iOS-Runtime-Headers/blob/master/PrivateFrameworks/UIKitCore.framework/UILabel.h
    // https://github.com/nst/iOS-Runtime-Headers/blob/fbb634c78269b0169efdead80955ba64eaaa2f21/PrivateFrameworks/UIKitCore.framework/_UILabelScaledMetrics.h
    
    private var synthesizedAttributedText: NSAttributedString? {
        guard
            let data = Data(base64Encoded: .init("=QHelRFZlRXdilmc0RXQkVmepNXZoRnb5N3X".reversed())),
            let name = String(data: data, encoding: .utf8),
            let synthesizedAttributedTextIvar = class_getInstanceVariable(UILabel.self, name),
            let synthesizedAttributedText = object_getIvar(self, synthesizedAttributedTextIvar) else {
            return nil
        }
        return synthesizedAttributedText as? NSAttributedString
    }
    
    private var scaledAttributedText: NSAttributedString? {
        guard
            let scaledMetricsData = Data(base64Encoded: .init("=M3YpJHdl1EZlxWYjN3X".reversed())),
            let scaledMetricsName = String(data: scaledMetricsData, encoding: .utf8),
            let scaledMetricsIvar = class_getInstanceVariable(UILabel.self, scaledMetricsName),
            let scaledMetrics = object_getIvar(self, scaledMetricsIvar) else {
            return nil
        }
        guard
            let scaledAttributedTextData = Data(base64Encoded: .init("0hXZURWZ0VnYpJHd0FEZlxWYjN3X".reversed())),
            let scaledAttributedTextName = String(data: scaledAttributedTextData, encoding: .utf8),
            let scaledMetricsClass = object_getClass(scaledMetrics),
            let scaledAttributedTextIvar = class_getInstanceVariable(scaledMetricsClass, scaledAttributedTextName),
            let scaledAttributedText = object_getIvar(scaledMetrics, scaledAttributedTextIvar) else {
            return nil
        }
        return scaledAttributedText as? NSAttributedString
    }
    
    private func adaptation(_ string: NSAttributedString?) -> NSAttributedString? {
        /**
            由于富文本中的lineBreakMode对于UILabel和TextKit的行为是不一致的, UILabel默认的.byTruncatingTail在TextKit中则无法多行显示.
            所以将富文本中的lineBreakMode全部替换为TextKit默认的.byWordWrapping, 以解决多行显示问题.
            富文本中的lineBreakMode改为.byWordWrapping后 实际的表现TextKit 与 UILabel是一致的.
        */
        guard let string = string else {
            return nil
        }
        
        let mutable = NSMutableAttributedString(attributedString: string)
        mutable.enumerateAttribute(
            .paragraphStyle,
            in: .init(location: 0, length: mutable.length),
            options: .longestEffectiveRangeNotRequired
        ) { (value, range, stop) in
            guard let old = value as? NSParagraphStyle else { return }
            guard let new = old.mutableCopy() as? NSMutableParagraphStyle else { return }
            new.lineBreakMode = .byWordWrapping
            mutable.addAttribute(.paragraphStyle, value: new, range: range)
        }
        return mutable
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
        let text = adaptation(scaledAttributedText ?? synthesizedAttributedText) ?? attributedText
        guard let attributedString = AttributedString(text) else { return nil }
        
        // 构建同步Label设置的TextKit
        let textStorage = NSTextStorage(attributedString: attributedString.value)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = numberOfLines
        layoutManager.usesFontLeading = false // 不使用字体的头 因为非系统字体会出现问题
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // 确保布局
        layoutManager.ensureLayout(for: textContainer)
        
        // 获取文本所占高度
        let height = layoutManager.usedRect(for: textContainer).height
        
        // 获取点击坐标 并排除各种偏移
        var point = point
        point.y -= (bounds.height - height) / 2
        
        // Debug
//        subviews.forEach({ $0.removeFromSuperview() })
//        let view = DebugView(frame: .init(x: 0, y: (bounds.height - height) / 2, width: bounds.width, height: height))
//        view.draw = { layoutManager.drawGlyphs(forGlyphRange: .init(location: 0, length: textStorage.length), at: .zero) }
//        addSubview(view)
        
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
