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
private var UITextViewAttachmentViewsKey: Void?

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
                base.touched = nil
                base.attributedText = newValue.value
            }
            
            setupActions(newValue)
            setupViewAttachments(newValue)
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
    
    /// 刷新布局 (如果有ViewAttachment的话)
    public func layout() {
        base.layout()
    }
}

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
    private func setupActions(_ string: AttributedString) {
        // 清理原有动作记录
        base.actions = [:]
        
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
    
    /// 设置视图附件
    private func setupViewAttachments(_ string: AttributedString) {
        // 清理原有监听
        observations = [:]
        
        // 清理原有视图
        for view in base.subviews where view is AttachmentView {
            view.removeFromSuperview()
        }
        base.attachmentViews = [:]
        
        // 获取视图附件
        let attachments: [NSRange: AttributedString.ViewAttachment] = string.value.get(.attachment)
        
        guard !attachments.isEmpty else {
            return
        }
        
        // 添加子视图
        attachments.forEach {
            let view = AttachmentView($0.value.view, with: $0.value.style)
            base.addSubview(view)
            base.attachmentViews[$0.key] = view
        }
        // 刷新布局
        base.layout()
        
        // 设置视图相关监听 同步更新布局
        observations["bounds"] = base.observe(\.bounds, options: [.new, .old]) { (object, changed) in
            object.layout(true)
        }
        observations["frame"] = base.observe(\.frame, options: [.new, .old]) { (object, changed) in
            guard changed.newValue?.size != changed.oldValue?.size else { return }
            object.layout()
        }
    }
}

#endif

#if os(iOS)

extension UITextView {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Checkings = [Checking: ([Highlight], ((NSRange, Checking.Result)) -> Void)]
    
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
        guard
            isActionEnabled,
            let touch = touches.first,
            let (range, action) = matching(touch.location(in: self)) else {
            super.touchesBegan(touches, with: event)
            return
        }
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
        guard
            isActionEnabled,
            let touched = self.touched else {
            super.touchesEnded(touches, with: event)
            return
        }
        self.touched = nil
        attributedText = touched.0.value
        layout()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            isActionEnabled,
            let touched = self.touched else {
            super.touchesCancelled(touches, with: event)
            return
        }
        self.touched = nil
        attributedText = touched.0.value
        layout()
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
        // 确保布局
        layoutManager.ensureLayout(for: textContainer)
        
        // 获取点击坐标 并排除各种偏移
        var point = point
        point.x -= textContainerInset.left
        point.y -= textContainerInset.top
        /**
        // Debug
        subviews.filter({ $0 is DebugView }).forEach({ $0.removeFromSuperview() })
        let height = layoutManager.usedRect(for: textContainer).height
        let view = DebugView(frame: .init(x: textContainerInset.left, y: textContainerInset.top, width: bounds.width, height: height))
        view.draw = { self.layoutManager.drawGlyphs(forGlyphRange: .init(location: 0, length: self.textStorage.length), at: .zero) }
        addSubview(view)
        */
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

fileprivate extension UITextView {
    
    /// 附件视图
    var attachmentViews: [NSRange: AttachmentView] {
        get { associated.get(&UITextViewAttachmentViewsKey) ?? [:] }
        set { associated.set(retain: &UITextViewAttachmentViewsKey, newValue) }
    }
    
    /// 布局
    /// - Parameter isVisible: 是否仅可视范围
    func layout(_ isVisible: Bool = false) {
        guard !attachmentViews.isEmpty else {
            return
        }
        
        func update(_ range: NSRange, _ view: AttachmentView) {
            view.isHidden = false
            // 获取字形范围
            let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
            // 获取边界大小
            var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
            rect.origin.x += textContainerInset.left
            rect.origin.y += textContainerInset.top
            view.frame = rect
        }
        
        if isVisible {
            // 获取可见范围
            let offset = CGPoint(contentOffset.x - textContainerInset.left, contentOffset.y - textContainerInset.top)
            let visible = layoutManager.glyphRange(forBoundingRect: .init(offset, bounds.size), in: textContainer)
            // 更新可见范围内的视图位置 同时隐藏可见范围外的视图
            for (range, view) in attachmentViews {
                if visible.contains(range.location) {
                    // 确保布局
                    layoutManager.ensureLayout(forCharacterRange: range)
                    // 更新视图
                    update(range, view)
                    
                } else {
                    view.isHidden = true
                }
            }
            
        } else {
            // 完成布局刷新
            layoutIfNeeded()
            // 废弃当前布局 重新计算
            layoutManager.invalidateLayout(
                forCharacterRange: .init(location: 0, length: textStorage.length),
                actualCharacterRange: nil
            )
            // 确保布局
            layoutManager.ensureLayout(for: textContainer)
            // 更新全部视图位置
            attachmentViews.forEach(update)
        }
    }
}

/// 附件视图
private class AttachmentView: UIView {
    
    typealias Style = AttributedString.Attachment.Style
    
    let view: UIView
    let style: Style
    
    private var observation: [String: NSKeyValueObservation] = [:]
    
    init(_ view: UIView, with style: Style) {
        self.view = view
        self.style = style
        super.init(frame: view.bounds)
        
        clipsToBounds = true
        backgroundColor = .clear
        
        addSubview(view)
        
        // 监听子视图位置变化 固定位置
        observation["frame"] = view.observe(\.frame) { [weak self] (object, changed) in
            guard let self = self else { return }
            self.update()
        }
        observation["bounds"] = view.observe(\.bounds) { [weak self] (object, changed) in
            guard let self = self else { return }
            self.update()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
    private func update() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.center = .init(bounds.width * 0.5, bounds.height * 0.5)
        switch style.mode {
        case .proposed:
            view.transform = .init(
                scaleX: bounds.width / view.bounds.width,
                y: bounds.height / view.bounds.height
            )
            
        case .original:
            let ratio = view.bounds.width / view.bounds.height
            view.transform = .init(
                scaleX: bounds.width / view.bounds.width,
                y: bounds.width / ratio / view.bounds.height
            )
            
        case .custom(let size):
            view.transform = .init(
                scaleX: size.width / view.bounds.width,
                y: size.height / view.bounds.height
            )
        }
        CATransaction.commit()
    }
}

#endif
#endif
