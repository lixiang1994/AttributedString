//
//  DebugLabelView.swift
//  Demo
//
//  Created by Lee on 2020/8/7.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class DebugLabelView: UIView {
    
    var labelWidth: CGFloat {
        .init(currentWidthSlider.value)
    }
    var labelHeight: CGFloat {
        .init(currentHeightSlider.value)
    }
    
    var font: UIFont = .systemFont(ofSize: 17) {
        didSet {
            let value = font.withSize(fontSize)
            label.font = value
            fontNameLabel.text = value.fontName
            let index = Debug.Label.fonts.firstIndex(where: { $0.fontName == font.fontName })
            fontNameSlider.value = .init(index ?? 0)
        }
    }
    var fontSize: CGFloat = 17 {
        didSet {
            let value = fontSize
            font = font.withSize(value)
            fontSizeLabel.text = String(format: "%.2f", value)
            fontSizeSlider.value = .init(value)
        }
    }
    var numberOfLines: Int = 0 {
        didSet {
            let value = numberOfLines
            label.numberOfLines = value
            numberOfLinesLabel.text = "\(value)"
            numberOfLinesSlider.value = .init(value)
        }
    }
    var textAlignment: NSTextAlignment = .natural {
        didSet {
            let value = textAlignment
            label.textAlignment = value
            textAlignmentLabel.text = value.description
            textAlignmentSlider.value = .init(value.rawValue)
        }
    }
    var lineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            let value = lineBreakMode
            label.lineBreakMode = value
            lineBreakModeLabel.text = value.description
            lineBreakModeSlider.value = .init(value.rawValue)
        }
    }
    var adjustsFontSizeToFitWidth: Bool = false {
        didSet {
            let value = adjustsFontSizeToFitWidth
            label.adjustsFontSizeToFitWidth = value
            adjustsFontSizeToFitWidthSwitch.isOn = value
            baselineAdjustmentSegmentedControl.isEnabled = value
            minimumScaleFactorSlider.isEnabled = value
            allowsDefaultTighteningForTruncationSwitch.isEnabled = value
        }
    }
    var baselineAdjustment: UIBaselineAdjustment = .alignBaselines {
        didSet {
            let value = baselineAdjustment
            label.baselineAdjustment = value
            baselineAdjustmentSegmentedControl.selectedSegmentIndex = value.rawValue
        }
    }
    var minimumScaleFactor: CGFloat = 0 {
        didSet {
            let value = minimumScaleFactor
            label.minimumScaleFactor = value
            minimumScaleFactorLabel.text = String(format: "%.2f", value)
            minimumScaleFactorSlider.value = .init(value)
            label.adjustsFontSizeToFitWidth.toggle()
            label.adjustsFontSizeToFitWidth.toggle()
        }
    }
    var allowsDefaultTighteningForTruncation: Bool = false {
        didSet {
            let value = allowsDefaultTighteningForTruncation
            label.allowsDefaultTighteningForTruncation = value
            allowsDefaultTighteningForTruncationSwitch.isOn = value
        }
    }
    
    var lineSpacing: CGFloat = 0 {
        didSet {
            let value = lineSpacing
            lineSpacingLabel.text = String(format: "%.2f", value)
            lineSpacingSlider.value = .init(value)
        }
    }
    
    var lineHeightMultiple: CGFloat = 0 {
        didSet {
            let value = lineHeightMultiple
            lineHeightMultipleLabel.text = String(format: "%.2f", value)
            lineHeightMultipleSlider.value = .init(value)
        }
    }
    
    var minimumLineHeight: CGFloat = 0 {
        didSet {
            let value = minimumLineHeight
            minimumLineHeightLabel.text = String(format: "%.2f", value)
            minimumLineHeightSlider.value = .init(value)
        }
    }
    
    var maximumLineHeight: CGFloat = 0 {
        didSet {
            let value = maximumLineHeight
            maximumLineHeightLabel.text = String(format: "%.2f", value)
            maximumLineHeightSlider.value = .init(value)
        }
    }
    
    var paragraphSpacing: CGFloat = 0 {
        didSet {
            let value = paragraphSpacing
            paragraphSpacingLabel.text = String(format: "%.2f", value)
            paragraphSpacingSlider.value = .init(value)
        }
    }
    
    var paragraphSpacingBefore: CGFloat = 0 {
        didSet {
            let value = paragraphSpacingBefore
            paragraphSpacingBeforeLabel.text = String(format: "%.2f", value)
            paragraphSpacingBeforeSlider.value = .init(value)
        }
    }
    
    var firstLineHeadIndent: CGFloat = 0 {
        didSet {
            let value = firstLineHeadIndent
            firstLineHeadIndentLabel.text = String(format: "%.2f", value)
            firstLineHeadIndentSlider.value = .init(value)
        }
    }
    var headIndent: CGFloat = 0 {
        didSet {
            let value = headIndent
            headIndentLabel.text = String(format: "%.2f", value)
            headIndentSlider.value = .init(value)
        }
    }
    
    var tailIndent: CGFloat = 0 {
        didSet {
            let value = tailIndent
            tailIndentLabel.text = String(format: "%.2f", value)
            tailIndentSlider.value = .init(value)
        }
    }
    
    @IBOutlet private weak var label: UILabel!
    
    @IBOutlet private weak var widthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    /// Page 1
    @IBOutlet private weak var currentWidthLabel: UILabel!
    @IBOutlet private weak var currentHeightLabel: UILabel!
    @IBOutlet private weak var currentWidthSlider: UISlider!
    @IBOutlet private weak var currentHeightSlider: UISlider!
    @IBOutlet private weak var currentWidthSwitch: UISwitch!
    @IBOutlet private weak var currentHeightSwitch: UISwitch!
    /// Page 2
    @IBOutlet private weak var fontNameLabel: UILabel!
    @IBOutlet private weak var fontNameSlider: UISlider!
    @IBOutlet private weak var fontSizeLabel: UILabel!
    @IBOutlet private weak var fontSizeSlider: UISlider!
    /// Page 3
    @IBOutlet private weak var numberOfLinesLabel: UILabel!
    @IBOutlet private weak var numberOfLinesSlider: UISlider!
    @IBOutlet private weak var textAlignmentLabel: UILabel!
    @IBOutlet private weak var textAlignmentSlider: UISlider!
    @IBOutlet private weak var lineBreakModeLabel: UILabel!
    @IBOutlet private weak var lineBreakModeSlider: UISlider!
    /// Page 4
    @IBOutlet private weak var adjustsFontSizeToFitWidthSwitch: UISwitch!
    @IBOutlet private weak var baselineAdjustmentSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var minimumScaleFactorLabel: UILabel!
    @IBOutlet private weak var minimumScaleFactorSlider: UISlider!
    @IBOutlet private weak var allowsDefaultTighteningForTruncationSwitch: UISwitch!
    /// Page 5
    @IBOutlet private weak var lineSpacingLabel: UILabel!
    @IBOutlet private weak var lineSpacingSlider: UISlider!
    @IBOutlet private weak var lineHeightMultipleLabel: UILabel!
    @IBOutlet private weak var lineHeightMultipleSlider: UISlider!
    @IBOutlet private weak var minimumLineHeightLabel: UILabel!
    @IBOutlet private weak var minimumLineHeightSlider: UISlider!
    @IBOutlet private weak var maximumLineHeightLabel: UILabel!
    @IBOutlet private weak var maximumLineHeightSlider: UISlider!
    @IBOutlet private weak var paragraphSpacingLabel: UILabel!
    @IBOutlet private weak var paragraphSpacingSlider: UISlider!
    @IBOutlet private weak var paragraphSpacingBeforeLabel: UILabel!
    @IBOutlet private weak var paragraphSpacingBeforeSlider: UISlider!
    @IBOutlet private weak var firstLineHeadIndentLabel: UILabel!
    @IBOutlet private weak var firstLineHeadIndentSlider: UISlider!
    @IBOutlet private weak var headIndentLabel: UILabel!
    @IBOutlet private weak var headIndentSlider: UISlider!
    @IBOutlet private weak var tailIndentLabel: UILabel!
    @IBOutlet private weak var tailIndentSlider: UISlider!
    
    private var labelBoundsObservation: NSKeyValueObservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置字体名称滑块最大值
        fontNameSlider.maximumValue = .init(Debug.Label.fonts.count - 1)
        // 设置label监听
        labelBoundsObservation = label.observe(\.bounds) { [weak self] (object, changed) in
            guard let self = self else { return }
            // 设置当前宽高
            self.currentWidthLabel.text = String(format: "%.2f", object.bounds.width)
            self.currentHeightLabel.text = String(format: "%.2f", object.bounds.height)
            // 设置当前滑块值
            self.currentWidthSlider.value = Float(object.bounds.width)
            self.currentHeightSlider.value = Float(object.bounds.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置最大选项页数
        pageControl.numberOfPages = .init(scrollView.contentSize.width / scrollView.bounds.width)
        // 设置最大可调宽高
        currentWidthSlider.minimumValue = 0
        currentWidthSlider.maximumValue = Float(bounds.width - 40)
        currentHeightSlider.minimumValue = 0
        currentHeightSlider.maximumValue = Float(bounds.height * 2)
    }
}

extension DebugLabelView {
    
    /// 设置当前信息
    /// - Parameter info: 配置信息
    func set(info: Debug.Label) {
        // size
        if let value = info.width {
            widthLayoutConstraint.constant = .init(value)
            widthLayoutConstraint.priority = .required
            currentWidthSwitch.isOn = true
            currentWidthSlider.isEnabled = true
            
        } else {
            widthLayoutConstraint.priority = .defaultLow
            currentWidthSwitch.isOn = false
            currentWidthSlider.isEnabled = false
        }
        if let value = info.height {
            heightLayoutConstraint.constant = .init(value)
            heightLayoutConstraint.priority = .required
            currentHeightSwitch.isOn = true
            currentHeightSlider.isEnabled = true
            
        } else {
            heightLayoutConstraint.priority = .defaultLow
            currentHeightSwitch.isOn = false
            currentHeightSlider.isEnabled = false
        }
        
        // normal
        font = info.font ?? .systemFont(ofSize: 17)
        fontSize = info.font?.pointSize ?? 17
        numberOfLines = info.numberOfLines ?? 0
        textAlignment = info.textAlignment ?? .natural
        lineBreakMode = info.lineBreakMode ?? .byTruncatingTail
        adjustsFontSizeToFitWidth = info.adjustsFontSizeToFitWidth ?? false
        baselineAdjustment = info.baselineAdjustment ?? .alignBaselines
        minimumScaleFactor = info.minimumScaleFactor ?? 0
        allowsDefaultTighteningForTruncation = info.allowsDefaultTighteningForTruncation ?? false
        
        // paragraphs
        lineSpacing = info.lineSpacing ?? 0
        lineHeightMultiple = info.lineHeightMultiple ?? 0
        minimumLineHeight = info.minimumLineHeight ?? 0
        maximumLineHeight = info.maximumLineHeight ?? 0
        paragraphSpacing = info.paragraphSpacing ?? 0
        paragraphSpacingBefore = info.paragraphSpacingBefore ?? 0
        firstLineHeadIndent = info.firstLineHeadIndent ?? 0
        headIndent = info.headIndent ?? 0
        tailIndent = info.tailIndent ?? 0
        
        // 刷新布局
        layoutIfNeeded()
    }
    
    /// 设置富文本
    /// - Parameter text: 富文本
    func set(text: AttributedString) {
        // 富文本中如果包含段落样式 则无法进行多行字号缩放
        label.attributed.text = text
        // 刷新布局
        layoutIfNeeded()
    }
    
    /// 设置当前页数
    /// - Parameter page: 页数
    /// - Parameter scroll: 是否同步滚动
    func set(page: Int, scroll: Bool) {
        pageControl.currentPage = page
        guard scroll else { return }
        let x = scrollView.bounds.width * .init(page)
        scrollView.contentOffset = .init(x: x, y: 0)
    }
}

private extension NSTextAlignment {
    
    var description: String {
        switch self {
        case .left:                     return "left"
        case .center:                   return "center"
        case .right:                    return "right"
        case .justified:                return "justified"
        case .natural:                  return "natural"
        @unknown default:               return "unknown"
        }
    }
}

private extension NSLineBreakMode {
    
    var description: String {
        switch self {
        case .byWordWrapping:           return "byWordWrapping"
        case .byCharWrapping:           return "byCharWrapping"
        case .byClipping:               return "byClipping"
        case .byTruncatingHead:         return "byTruncatingHead"
        case .byTruncatingTail:         return "byTruncatingTail"
        case .byTruncatingMiddle:       return "byTruncatingMiddle"
        @unknown default:               return "unknown"
        }
    }
}
