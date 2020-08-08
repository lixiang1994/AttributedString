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
        }
    }
    private var numberOfLines: Int {
        get { container.label.numberOfLines }
        set {
            container.label.numberOfLines = newValue
            container.numberOfLinesLabel.text = "\(newValue)"
        }
    }
    private var textAlignment: NSTextAlignment {
        get { container.label.textAlignment }
        set {
            container.label.textAlignment = newValue
            container.textAlignmentLabel.text = newValue.description
        }
    }
    
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
        // 设置当前字体
        font = fonts.first
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
        container.labelWidth.priority = sender.isOn ? .required : .defaultLow
        container.currentWidthSlider.isEnabled = sender.isOn
    }
    @IBAction func heightSwitchAction(_ sender: UISwitch) {
        container.labelHeight.priority = sender.isOn ? .required : .defaultLow
        container.currentHeightSlider.isEnabled = sender.isOn
    }
    
    @IBAction func widthSliderAction(_ sender: UISlider) {
        container.labelWidth.constant = CGFloat(sender.value)
        view.layoutIfNeeded()
    }
    @IBAction func heightSliderAction(_ sender: UISlider) {
        container.labelHeight.constant = CGFloat(sender.value)
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
        case .left:         return "left"
        case .center:       return "center"
        case .right:        return "right"
        case .justified:    return "justified"
        case .natural:      return "natural"
        @unknown default:   return "unknown"
        }
    }
}
