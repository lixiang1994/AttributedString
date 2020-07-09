//
//  NSTextFieldExtension.swift
//  AttributedString
//
//  Created by Lee on 2020/4/8.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(macOS)

import AppKit

private var NSGestureRecognizerKey: Void?
private var NSEventMonitorKey: Void?
private var NSTextFieldTouchedKey: Void?
private var NSTextFieldActionsKey: Void?
private var NSTextFieldCheckingsKey: Void?

extension NSTextField: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: NSTextField {

    public var string: AttributedString {
        get { base.touched?.0 ?? .init(base.attributedStringValue) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var current = base.touched, current.0.isContentEqual(to: newValue) {
                current.0 = newValue
                base.touched = current
                
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: newValue.value)
                base.attributedStringValue.get(current.1).forEach { (range, attributes) in
                    temp.setAttributes(attributes, range: range)
                }
                base.attributedStringValue = temp
                
            } else {
                base.attributedStringValue = AttributedString(
                    newValue.value,
                    .font(base.font ?? .systemFont(ofSize: 13)),
                    .paragraph(
                        .alignment(base.alignment),
                        .baseWritingDirection(base.baseWritingDirection)
                    )
                ).value
            }
            
            // 设置动作和手势
            setupActions(newValue)
            setupGestureRecognizers()
        }
    }
    
    public var placeholder: AttributedString? {
        get { AttributedString(base.placeholderAttributedString) }
        set { base.placeholderAttributedString = newValue?.value }
    }
}

extension AttributedStringWrapper where Base: NSTextField {
    
    private(set) var gestures: [NSGestureRecognizer] {
        get { base.associated.get(&NSGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &NSGestureRecognizerKey, newValue) }
    }
    
    private(set) var monitors: [Any] {
        get { base.associated.get(&NSEventMonitorKey) ?? [] }
        set { base.associated.set(retain: &NSEventMonitorKey, newValue) }
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
                var action = Action(.click, highlights: value.0)
                action.handle = {
                    value.1(result)
                }
                base.actions[range] = action
            }
        }
    }
    
    /// 设置手势识别
    private func setupGestureRecognizers() {
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        Set(base.actions.values.map({ $0.trigger })).forEach {
            switch $0 {
            case .click:
                let gesture = NSClickGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
                
            case .press:
                let gesture = NSPressGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
            }
        }
        
        monitors.forEach { NSEvent.removeMonitor($0) }
        monitors = []
        guard base.isActionEnabled else { return }
        if let monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown, handler: { (event) -> NSEvent? in
            self.base.attributed_mouseDown(with: event)
            return event
        }) {
            monitors.append(monitor)
        }
        if let monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseUp, handler: { (event) -> NSEvent? in
            self.base.attributed_mouseUp(with: event)
            return event
        }) {
            monitors.append(monitor)
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

extension NSTextField {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Checkings = [Checking: ([Highlight], (Checking.Result) -> Void)]
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && (!isEditable && !isSelectable)
    }
    
    /// 触摸信息
    fileprivate var touched: (AttributedString, NSRange, Action)? {
        get { associated.get(&NSTextFieldTouchedKey) }
        set { associated.set(retain: &NSTextFieldTouchedKey, newValue) }
    }
    /// 全部动作
    fileprivate var actions: [NSRange: Action] {
        get { associated.get(&NSTextFieldActionsKey) ?? [:] }
        set { associated.set(retain: &NSTextFieldActionsKey, newValue) }
    }
    /// 监听信息
    fileprivate var checkings: Checkings {
        get { associated.get(&NSTextFieldCheckingsKey) ?? [:] }
        set { associated.set(retain: &NSTextFieldCheckingsKey, newValue) }
    }
    
    @objc
    func attributed_mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        guard bounds.contains(point), window == event.window else { return }
        guard isActionEnabled else { return }
        guard let (range, action) = matching(point) else { return }
        let string = attributed.string
        // 备份当前信息
        touched = (string, range, action)
        // 设置高亮样式
        var temp: [NSAttributedString.Key: Any] = [:]
        action.highlights.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        self.attributedStringValue = attributedStringValue.reset(range: range) { (attributes) in
            attributes.merge(temp, uniquingKeysWith: { $1 })
        }
    }
    
    @objc
    func attributed_mouseUp(with event: NSEvent) {
        guard isActionEnabled else { return }
        DispatchQueue.main.async {
            guard let current = self.touched else { return }
            self.touched = nil
            self.attributedStringValue = current.0.value
        }
    }
}

fileprivate extension NSTextField {
    
    @objc
    func attributedAction(_ sender: NSGestureRecognizer) {
        guard isActionEnabled else { return }
        guard let action = touched?.2 else { return }
        guard action.trigger.matching(sender) else { return }
        // 点击 回调
        action.handle?()
    }
    
    func matching(_ point: CGPoint) -> (NSRange, Action)? {
        let attributedString = AttributedString(attributedStringValue)
        
        // 构建同步Label设置的TextKit
        let textStorage = NSTextStorage(attributedString: attributedString.value)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.usesFontLeading = false // 不使用字体的头 因为非系统字体会出现问题
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = usesSingleLineMode ? 1 : 0
        
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
