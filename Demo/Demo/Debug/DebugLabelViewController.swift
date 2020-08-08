//
//  DebugLabelViewController.swift
//  Demo
//
//  Created by Lee on 2020/8/7.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class DebugLabelViewController: ViewController<DebugLabelView> {
    
    private let fonts: [UIFont] = [
        .systemFont(ofSize: 17.0),
        .systemFont(ofSize: 17.0, weight: .light),
        .systemFont(ofSize: 17.0, weight: .medium),
        .systemFont(ofSize: 17.0, weight: .semibold),
        .systemFont(ofSize: 17.0, weight: .black),
        UIFont(name: "Georgia", size: 17.0) ?? .systemFont(ofSize: 17.0),
        UIFont(name: "Helvetica", size: 17.0) ?? .systemFont(ofSize: 17.0),
        UIFont(name: "Helvetica Neue", size: 17.0) ?? .systemFont(ofSize: 17.0),
        UIFont(name: "Times New Roman", size: 17.0) ?? .systemFont(ofSize: 17.0)
    ]
    
    private var font: UIFont? {
        didSet {
            let temp = font?.withSize(fontSize)
            container.label.font = temp
            container.fontNameLabel.text = temp?.fontName
        }
    }
    private var fontSize: CGFloat = 17.0 {
        didSet {
            font = font?.withSize(fontSize)
            container.fontSizeLabel.text = String(format: "%.2f", fontSize)
            container.fontSizeSlider.value = .init(fontSize)
        }
    }
    private var numberOfLines: Int {
        get { container.label.numberOfLines }
        set {
            container.label.numberOfLines = newValue
            container.numberOfLinesLabel.text = "\(newValue)"
            container.numberOfLinesSlider.value = .init(newValue)
        }
    }
    private var textAlignment: NSTextAlignment {
        get { container.label.textAlignment }
        set {
            container.label.textAlignment = newValue
            container.textAlignmentLabel.text = newValue.description
            container.textAlignmentSlider.value = .init(newValue.rawValue)
        }
    }
    private var lineBreakMode: NSLineBreakMode {
        get { container.label.lineBreakMode }
        set {
            container.label.lineBreakMode = newValue
            container.lineBreakModeLabel.text = newValue.description
            container.lineBreakModeSlider.value = .init(newValue.rawValue)
        }
    }
    private var adjustsFontSizeToFitWidth: Bool {
        get { container.label.adjustsFontSizeToFitWidth }
        set {
            container.label.adjustsFontSizeToFitWidth = newValue
            container.adjustsFontSizeToFitWidthSwitch.isOn = newValue
            container.baselineAdjustmentSegmentedControl.isEnabled = newValue
            container.minimumScaleFactorSlider.isEnabled = newValue
            container.allowsDefaultTighteningForTruncationSwitch.isEnabled = newValue
        }
    }
    private var baselineAdjustment: UIBaselineAdjustment {
        get { container.label.baselineAdjustment }
        set {
            container.label.baselineAdjustment = newValue
            container.baselineAdjustmentSegmentedControl.selectedSegmentIndex = newValue.rawValue
        }
    }
    private var minimumScaleFactor: CGFloat {
        get { container.label.minimumScaleFactor }
        set {
            container.label.minimumScaleFactor = newValue
            container.minimumScaleFactorLabel.text = String(format: "%.2f", newValue)
            container.minimumScaleFactorSlider.value = .init(newValue)
        }
    }
    private var allowsDefaultTighteningForTruncation: Bool {
        get { container.label.allowsDefaultTighteningForTruncation }
        set {
            container.label.allowsDefaultTighteningForTruncation = newValue
            container.allowsDefaultTighteningForTruncationSwitch.isOn = newValue
        }
    }
    
    private var widthLayoutConstraint: NSLayoutConstraint?
    private var heightLayoutConstraint: NSLayoutConstraint?
    
    private var attributes: [AttributedString.Attribute] = []
    private var paragraphs: [AttributedString.Attribute.ParagraphStyle] = []
    private var attributedString: AttributedString = """
        我的名字叫李响，我的手机号码是18611401994，我的电子邮件地址是18611401994@163.com，现在是2020/06/28 20:30。我的GitHub主页是https://github.com/lixiang1994。欢迎来Star! \("点击联系我", .action({ }))
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        update()
    }
    
    private func setup() {
        // 设置默认属性
        font = fonts.first
        fontSize = 17.0
        numberOfLines = 0
        textAlignment = .natural
        lineBreakMode = .byTruncatingTail
        adjustsFontSizeToFitWidth = false
        baselineAdjustment = .alignBaselines
        minimumScaleFactor = 0.0
        allowsDefaultTighteningForTruncation = false
    }
    
    private func update() {
        container.label.attributed.text = .init(
            attributedString,
            with: attributes + [.paragraph(paragraphs)]
        )
    }
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        let x = container.scrollView.bounds.width * .init(sender.currentPage)
        container.scrollView.contentOffset = .init(x: x, y: 0)
    }
    
    @IBAction func widthSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            let layoutConstraint = container.label.widthAnchor.constraint(
                equalToConstant: .init(container.currentWidthSlider.value)
            )
            widthLayoutConstraint = layoutConstraint
            container.label.addConstraint(layoutConstraint)
            
        } else {
            guard let layoutConstraint = widthLayoutConstraint else { return }
            widthLayoutConstraint = nil
            container.label.removeConstraint(layoutConstraint)
        }
        container.currentWidthSlider.isEnabled = sender.isOn
    }
    @IBAction func heightSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            let layoutConstraint = container.label.heightAnchor.constraint(
                equalToConstant: .init(container.currentHeightSlider.value)
            )
            heightLayoutConstraint = layoutConstraint
            container.label.addConstraint(layoutConstraint)
            
        } else {
            guard let layoutConstraint = heightLayoutConstraint else { return }
            heightLayoutConstraint = nil
            container.label.removeConstraint(layoutConstraint)
        }
        container.currentHeightSlider.isEnabled = sender.isOn
    }
    
    @IBAction func widthSliderAction(_ sender: UISlider) {
        widthLayoutConstraint?.constant = .init(sender.value)
        view.layoutIfNeeded()
    }
    @IBAction func heightSliderAction(_ sender: UISlider) {
        heightLayoutConstraint?.constant = .init(sender.value)
        view.layoutIfNeeded()
    }
    
    @IBAction func fontNameSliderAction(_ sender: UISlider) {
        font = fonts[.init(sender.value)]
    }
    @IBAction func fontSizeSliderAction(_ sender: UISlider) {
        fontSize = .init(sender.value)
    }
    
    @IBAction func numberOfLinesSliderAction(_ sender: UISlider) {
        numberOfLines = .init(sender.value)
    }
    @IBAction func textAlignmentSliderAction(_ sender: UISlider) {
        textAlignment = NSTextAlignment(rawValue: .init(sender.value)) ?? .natural
    }
    @IBAction func lineBreakModeSliderAction(_ sender: UISlider) {
        lineBreakMode = NSLineBreakMode(rawValue: .init(sender.value)) ?? .byTruncatingTail
    }
    
    @IBAction func adjustsFontSizeToFitWidthSwitchAction(_ sender: UISwitch) {
        adjustsFontSizeToFitWidth = sender.isOn
        update()
    }
    @IBAction func baselineAdjustmentSegmentedAction(_ sender: UISegmentedControl) {
        baselineAdjustment = UIBaselineAdjustment(rawValue: sender.selectedSegmentIndex) ?? .alignBaselines
    }
    @IBAction func minimumScaleFactorSlider(_ sender: UISlider) {
        minimumScaleFactor = .init(sender.value)
        // 需要关闭再开启才会更新
        container.label.adjustsFontSizeToFitWidth.toggle()
        container.label.adjustsFontSizeToFitWidth.toggle()
        update()
    }
    @IBAction func allowsDefaultTighteningForTruncationSwitchAction(_ sender: UISwitch) {
        allowsDefaultTighteningForTruncation = sender.isOn
    }
    
    @IBAction func lineSpacingSliderAction(_ sender: UISlider) {
        paragraphs.append(.lineSpacing(.init(sender.value)))
        container.lineSpacingLabel.text = String(format: "%.2f", sender.value)
        update()
    }
    @IBAction func lineHeightMultipleSliderAction(_ sender: UISlider) {
        paragraphs.append(.lineHeightMultiple(.init(sender.value)))
        container.lineHeightMultipleLabel.text = String(format: "%.2f", sender.value)
        update()
    }
}

extension DebugLabelViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.x + scrollView.bounds.width * 0.5).rounded(.down)
        container.pageControl.currentPage = .init(offset / scrollView.bounds.width)
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
