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
        guard
            isActionEnabled,
            let string = attributed.text,
            let touch = touches.first,
            let (range, action) = matching(touch.location(in: self)) else {
            super.touchesBegan(touches, with: event)
            return
        }
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
        let text = adaptation(scaledAttributedText ?? synthesizedAttributedText ?? attributedText, with: numberOfLines)
        guard let attributedString = AttributedString(text) else { return nil }
        
        // 构建同步Label的TextKit
        let delegate = UILabelLayoutManagerDelegate(scaledMetrics, with: baselineAdjustment)
        let textStorage = NSTextStorage()
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.delegate = delegate // 重新计算行高确保TextKit与UILabel显示同步
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = numberOfLines
        layoutManager.usesFontLeading = false   // UILabel没有使用FontLeading排版
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.setAttributedString(attributedString.value) // 放在最后添加富文本 TextKit的坑
        
        // 确保布局
        layoutManager.ensureLayout(for: textContainer)
        
        // 获取文本所占高度
        let height = layoutManager.usedRect(for: textContainer).height
        
        // 获取点击坐标 并排除各种偏移
        var point = point
        point.y -= (bounds.height - height) / 2
        
        // Debug
//        subviews.filter({ $0 is DebugView }).forEach({ $0.removeFromSuperview() })
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

class DebugView: UIView {
    
    var draw: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2983732877)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.draw?()
    }
}

private extension String {
    
    func reversedBase64Decoder() -> String? {
        guard let data = Data(base64Encoded: .init(self.reversed())) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension UILabel {
    // Runtime Headers
    // https://github.com/nst/iOS-Runtime-Headers/blob/master/PrivateFrameworks/UIKitCore.framework/UILabel.h
    // https://github.com/nst/iOS-Runtime-Headers/blob/fbb634c78269b0169efdead80955ba64eaaa2f21/PrivateFrameworks/UIKitCore.framework/_UILabelScaledMetrics.h
    
    struct ScaledMetrics {
        let actualScaleFactor: Double
        let baselineOffset: Double
        let measuredNumberOfLines: Int64
        let scaledAttributedText: NSAttributedString
        let scaledBaselineOffset: Double
        let scaledLineHeight: Double
        let scaledSize: CGSize
        let targetSize: CGSize
        
        /// Keys
        
        static let actualScaleFactorName = "y9GdjFmRlxWYjNFbhVHdjF2X".reversedBase64Decoder()
        static let baselineOffsetName = "0V2cmZ2Tl5WasV2chJ2X".reversedBase64Decoder()
        static let measuredNumberOfLinesName = "==wcl5WaMZ2TyVmYtVnTkVmc1NXYl12X".reversedBase64Decoder()
        static let scaledAttributedTextName = "0hXZURWZ0VnYpJHd0FEZlxWYjN3X".reversedBase64Decoder()
        static let scaledBaselineOffsetName = "0V2cmZ2Tl5WasV2chJEZlxWYjN3X".reversedBase64Decoder()
        static let scaledLineHeightName = "=QHanlWZIVmbpxEZlxWYjN3X".reversedBase64Decoder()
        static let scaledSizeName = "=UmepNFZlxWYjN3X".reversedBase64Decoder()
        static let targetSizeName = "=UmepNFdldmchR3X".reversedBase64Decoder()
    }
    
    private static let synthesizedAttributedTextName = "=QHelRFZlRXdilmc0RXQkVmepNXZoRnb5N3X".reversedBase64Decoder()
    private var synthesizedAttributedText: NSAttributedString? {
        guard
            let name = UILabel.synthesizedAttributedTextName,
            let ivar = class_getInstanceVariable(UILabel.self, name),
            let synthesizedAttributedText = object_getIvar(self, ivar) else {
            return nil
        }
        return synthesizedAttributedText as? NSAttributedString
    }
    
    private static let scaledMetricsName = "=M3YpJHdl1EZlxWYjN3X".reversedBase64Decoder()
    private var scaledMetrics: ScaledMetrics? {
        guard
            let name = UILabel.scaledMetricsName,
            let ivar = class_getInstanceVariable(UILabel.self, name),
            let object = object_getIvar(self, ivar) as? NSObject else {
            return nil
        }
        guard
            let actualScaleFactorName = ScaledMetrics.actualScaleFactorName,
            let baselineOffsetName = ScaledMetrics.baselineOffsetName,
            let measuredNumberOfLinesName = ScaledMetrics.measuredNumberOfLinesName,
            let scaledAttributedTextName = ScaledMetrics.scaledAttributedTextName,
            let scaledBaselineOffsetName = ScaledMetrics.scaledBaselineOffsetName,
            let scaledLineHeightName = ScaledMetrics.scaledLineHeightName,
            let scaledSizeName = ScaledMetrics.scaledSizeName,
            let targetSizeName = ScaledMetrics.targetSizeName else {
            return nil
        }
        guard
            let actualScaleFactor = object.value(forKey: actualScaleFactorName) as? Double,
            let baselineOffset = object.value(forKey: baselineOffsetName) as? Double,
            let measuredNumberOfLines = object.value(forKey: measuredNumberOfLinesName) as? Int64,
            let scaledAttributedText = object.value(forKey: scaledAttributedTextName) as? NSAttributedString,
            let scaledBaselineOffset = object.value(forKey: scaledBaselineOffsetName) as? Double,
            let scaledLineHeight = object.value(forKey: scaledLineHeightName) as? Double,
            let scaledSize = object.value(forKey: scaledSizeName) as? CGSize,
            let targetSize = object.value(forKey: targetSizeName) as? CGSize else {
            return nil
        }
        
        return .init(
            actualScaleFactor: actualScaleFactor,
            baselineOffset: baselineOffset,
            measuredNumberOfLines: measuredNumberOfLines,
            scaledAttributedText: scaledAttributedText,
            scaledBaselineOffset: scaledBaselineOffset,
            scaledLineHeight: scaledLineHeight,
            scaledSize: scaledSize,
            targetSize: targetSize
        )
    }
    
    private var scaledAttributedText: NSAttributedString? {
        return scaledMetrics?.scaledAttributedText
    }
    
    private func adaptation(_ string: NSAttributedString?, with numberOfLines: Int) -> NSAttributedString? {
        /**
        由于富文本中的lineBreakMode对于UILabel和TextKit的行为是不一致的, UILabel默认的.byTruncatingTail在TextKit中则无法正确显示.
        所以将富文本中的lineBreakMode全部替换为TextKit默认的.byWordWrapping, 以解决多行显示和不一致的问题.
        注意: 经测试 最大行数为1行时 换行模式表现与byCharWrapping一致.
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
            new.lineBreakMode = numberOfLines == 1 ? .byCharWrapping : .byWordWrapping
            if #available(iOS 11.0, *) {
                new.setValue(1, forKey: "lineBreakStrategy")
            }
            mutable.addAttribute(.paragraphStyle, value: new, range: range)
        }
        return mutable
    }
}

#endif
#endif
