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
private var NSTextFieldObserversKey: Void?

extension NSTextField: ASAttributedStringCompatible {
    
}

extension ASAttributedStringWrapper where Base: NSTextField {

    public var string: ASAttributedString {
        get { base.touched?.0 ?? .init(base.attributedStringValue) }
        set {
            // 判断当前是否在触摸状态, 内容是否发生了变化
            if var current = base.touched, current.0.isContentEqual(to: newValue) {
                current.0 = newValue
                base.touched = current
                
                // 将当前的高亮属性覆盖到新文本中 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: newValue.value)
                let ranges = current.1.keys.sorted(by: { $0.length > $1.length })
                for range in ranges {
                    base.attributedStringValue.get(range).forEach { (range, attributes) in
                        temp.setAttributes(attributes, range: range)
                    }
                }
                base.attributedStringValue = temp
                
            } else {
                base.attributedStringValue = ASAttributedString(
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
    
    public var placeholder: ASAttributedString? {
        get { ASAttributedString(base.placeholderAttributedString) }
        set { base.placeholderAttributedString = newValue?.value }
    }
}

extension ASAttributedStringWrapper where Base: NSTextField {
    
    /// 添加监听
    /// - Parameters:
    ///   - checking: 检查类型
    ///   - action: 检查动作
    public func observe(_ checking: Checking, with action: Checking.Action) {
        var temp = base.observers
        if var value = temp[checking] {
            value.append(action)
            temp[checking] = value
            
        } else {
            temp[checking] = [action]
        }
        base.observers = temp
    }
    
    /// 添加监听
    /// - Parameters:
    ///   - checking: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checking: Checking,
                        highlights: [Highlight] = .defalut,
                        with callback: @escaping (Checking.Result) -> Void) {
        observe(checking, with: .init(.click, highlights: highlights, with: callback))
    }
    
    /// 添加监听
    /// - Parameters:
    ///   - checkings: 检查类型
    ///   - highlights: 高亮样式
    ///   - callback: 触发回调
    public func observe(_ checkings: [Checking] = .defalut,
                        highlights: [Highlight] = .defalut,
                        with callback: @escaping (Checking.Result) -> Void) {
        checkings.forEach {
            observe($0, highlights: highlights, with: callback)
        }
    }
    

    /// 移除监听
    /// - Parameter checking: 检查类型
    public func remove(checking: Checking) {
        base.observers.removeValue(forKey: checking)
    }
    /// 移除监听
    /// - Parameter checkings: 检查类型
    public func remove(checkings: [Checking]) {
        checkings.forEach { base.observers.removeValue(forKey: $0) }
    }
}

extension ASAttributedStringWrapper where Base: NSTextField {
    
    private(set) var gestures: [NSGestureRecognizer] {
        get { base.associated.get(&NSGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &NSGestureRecognizerKey, newValue) }
    }
    
    private(set) var monitors: [Any] {
        get { base.associated.get(&NSEventMonitorKey) ?? [] }
        set { base.associated.set(retain: &NSEventMonitorKey, newValue) }
    }
    
    /// 设置动作
    private func setupActions(_ string: ASAttributedString?) {
        // 清理原有动作记录
        base.actions = [:]
        
        guard let string = string else {
            return
        }
        // 获取当前动作
        base.actions = string.value.get(.action)
        // 获取匹配检查 添加检查动作
        let observers = base.observers
        string.matching(.init(observers.keys)).forEach { (range, checking) in
            let (type, result) = checking
            if var temp = base.actions[range] {
                for action in observers[type] ?? [] {
                    temp.append(
                        .init(
                            action.trigger,
                            action.highlights
                        ) { _ in
                            action.callback(result)
                        }
                    )
                }
                base.actions[range] = temp
                
            } else {
                base.actions[range] = observers[type]?.map { action in
                    .init(
                        action.trigger,
                        action.highlights
                    ) { _ in
                        action.callback(result)
                    }
                }
            }
        }
        
        // 统一为所有动作增加handle闭包
        base.actions = base.actions.reduce(into: [:]) {
            let result: Action.Result = string.value.get($1.key)
            let actions: [Action] = $1.value.reduce(into: []) {
                var temp = $1
                temp.result = result
                $0.append(temp)
            }
            $0[$1.key] = actions
        }
    }
    
    /// 设置手势识别
    private func setupGestureRecognizers() {
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        let triggers = base.actions.values.flatMap({ $0 }).map({ $0.trigger })
        Set(triggers).forEach {
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
}

extension NSTextField {
    
    fileprivate typealias Action = ASAttributedString.Action
    fileprivate typealias Checking = ASAttributedString.Checking
    fileprivate typealias Highlight = ASAttributedString.Action.Highlight
    fileprivate typealias Observers = [Checking: [Checking.Action]]
    
    /// 是否启用Action
    fileprivate var isActionEnabled: Bool {
        return !attributed.gestures.isEmpty && (!isEditable && !isSelectable)
    }
    
    /// 触摸信息
    fileprivate var touched: (ASAttributedString, [NSRange: [Action]])? {
        get { associated.get(&NSTextFieldTouchedKey) }
        set { associated.set(retain: &NSTextFieldTouchedKey, newValue) }
    }
    /// 全部动作
    fileprivate var actions: [NSRange: [Action]] {
        get { associated.get(&NSTextFieldActionsKey) ?? [:] }
        set { associated.set(retain: &NSTextFieldActionsKey, newValue) }
    }
    /// 监听信息
    fileprivate var observers: Observers {
        get { associated.get(&NSTextFieldObserversKey) ?? [:] }
        set { associated.set(retain: &NSTextFieldObserversKey, newValue) }
    }
    
    @objc
    func attributed_mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        guard bounds.contains(point), window == event.window else { return }
        guard isActionEnabled else { return }
        let results = matching(point)
        guard !results.isEmpty else { return }
        let string = attributed.string
        // 备份当前信息
        touched = (string, results)
        // 设置高亮样式
        let ranges = results.keys.sorted(by: { $0.length > $1.length })
        for range in ranges {
            var temp: [NSAttributedString.Key: Any] = [:]
            results[range]?.first?.highlights.forEach {
                temp.merge($0.attributes, uniquingKeysWith: { $1 })
            }
            attributedStringValue = attributedStringValue.reset(range: range) { (attributes) in
                attributes.merge(temp, uniquingKeysWith: { $1 })
            }
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
        guard sender.state == .ended else { return }
        guard isActionEnabled else { return }
        guard let touched = self.touched else { return }
        let actions = touched.1.flatMap({ $0.value })
        for action in actions where action.trigger.matching(sender) {
            guard let result = action.result else { return }
            action.callback(result)
        }
    }
    
    func matching(_ point: CGPoint) -> [NSRange: [Action]] {
        let attributedString = ASAttributedString(attributedStringValue)
        
        // 构建同步Label设置的TextKit
        let textStorage = NSTextStorage(attributedString: attributedString.value)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = usesSingleLineMode ? 1 : 0
        layoutManager.usesFontLeading = false // 不使用字体的头 因为非系统字体会出现问题
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        // 确保布局
        layoutManager.ensureLayout(for: textContainer)
        
        // 获取字形下标
        var fraction: CGFloat = 0
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: &fraction)
        // 获取字符下标
        let index = layoutManager.characterIndexForGlyph(at: glyphIndex)
        // 通过字形距离判断是否在字形范围内
        guard fraction > 0, fraction < 1 else {
            return [:]
        }
        // 获取点击的字符串范围和回调事件
        let ranges = actions.keys.filter({ $0.contains(index) })
        return ranges.reduce(into: [:]) {
            $0[$1] = actions[$1]
        }
    }
}

#endif
