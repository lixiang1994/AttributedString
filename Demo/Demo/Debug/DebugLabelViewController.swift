//
//  DebugLabelViewController.swift
//  Demo
//
//  Created by Lee on 2020/8/7.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

private let key = "com.debug.label"

class DebugLabelViewController: ViewController<DebugLabelView> {
    
    private var info: Debug.Label = .init() {
        didSet { set(info: info) }
    }
    
    private var attributes: [ASAttributedString.Attribute] = []
    private var paragraphs: [ASAttributedString.Attribute.ParagraphStyle] = []
    private var attributedString: ASAttributedString = """
    我的名字叫李响，我的手机号码是18611401994，我的电子邮件地址是18611401994@163.com，现在是2020/06/28 20:30。我的GitHub主页是https://github.com/lixiang1994。欢迎来Star! \("点击联系我", .action({ }))
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        updateText()
    }
    
    private func setup() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let info = try? JSONDecoder().decode(Debug.Label.self, from: data) else {
            return
        }
        self.info = info
    }
    
    private func set(info: Debug.Label) {
        
        func update(_ style: ASAttributedString.Attribute.ParagraphStyle) {
            paragraphs.removeAll(where: { $0 ~= style })
            paragraphs.append(style)
        }
        
        func remove(_ style: ASAttributedString.Attribute.ParagraphStyle) {
            paragraphs.removeAll(where: { $0 ~= style })
        }
        
        if let value = info.lineSpacing {
            update(.lineSpacing(value))
            
        } else {
            remove(.lineSpacing(0))
        }
        if let value = info.lineHeightMultiple {
            update(.lineHeightMultiple(value))
            
        } else {
            remove(.lineHeightMultiple(0))
        }
        if let value = info.minimumLineHeight {
            update(.minimumLineHeight(value))
            
        } else {
            remove(.minimumLineHeight(0))
        }
        if let value = info.maximumLineHeight {
            update(.maximumLineHeight(value))
            
        } else {
            remove(.maximumLineHeight(0))
        }
        if let value = info.paragraphSpacing {
            update(.paragraphSpacing(value))
            
        } else {
            remove(.paragraphSpacing(0))
        }
        if let value = info.paragraphSpacingBefore {
            update(.paragraphSpacingBefore(value))
            
        } else {
            remove(.paragraphSpacingBefore(0))
        }
        if let value = info.firstLineHeadIndent {
            update(.firstLineHeadIndent(value))
            
        } else {
            remove(.firstLineHeadIndent(0))
        }
        if let value = info.headIndent {
            update(.headIndent(value))
            
        } else {
            remove(.headIndent(0))
        }
        if let value = info.tailIndent {
            update(.tailIndent(value))
            
        } else {
            remove(.tailIndent(0))
        }
        container.set(info: info)
        updateText()
    }
    
    private func updateText() {
        container.set(text: .init(
            attributedString,
            with: attributes + [.paragraph(with: paragraphs)]
        ))
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let json = try? JSONEncoder().encode(info) else { return }
        UserDefaults.standard.setValue(json, forKey: key)
    }
    @IBAction func cleanAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: key)
        info = .init()
    }
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        container.set(page: sender.currentPage, scroll: true)
    }
    
    @IBAction func widthSwitchAction(_ sender: UISwitch) {
        info.width = sender.isOn ? container.labelWidth : .none
    }
    @IBAction func heightSwitchAction(_ sender: UISwitch) {
        info.height = sender.isOn ? container.labelHeight : .none
    }
    @IBAction func widthSliderAction(_ sender: UISlider) {
        info.width = .init(sender.value)
    }
    @IBAction func heightSliderAction(_ sender: UISlider) {
        info.height = .init(sender.value)
    }
    
    @IBAction func fontNameSliderAction(_ sender: UISlider) {
        info.font = Debug.Label.fonts[.init(sender.value)].withSize(info.font?.pointSize ?? 17.0)
    }
    @IBAction func fontSizeSliderAction(_ sender: UISlider) {
        info.font = info.font?.withSize(.init(sender.value))
    }
    @IBAction func numberOfLinesSliderAction(_ sender: UISlider) {
        info.numberOfLines = .init(sender.value)
    }
    @IBAction func textAlignmentSliderAction(_ sender: UISlider) {
        info.textAlignment = NSTextAlignment(rawValue: .init(sender.value)) ?? .natural
    }
    @IBAction func lineBreakModeSliderAction(_ sender: UISlider) {
        info.lineBreakMode = NSLineBreakMode(rawValue: .init(sender.value)) ?? .byTruncatingTail
    }
    
    @IBAction func adjustsFontSizeToFitWidthSwitchAction(_ sender: UISwitch) {
        info.adjustsFontSizeToFitWidth = sender.isOn
    }
    @IBAction func baselineAdjustmentSegmentedAction(_ sender: UISegmentedControl) {
        info.baselineAdjustment = UIBaselineAdjustment(rawValue: sender.selectedSegmentIndex) ?? .alignBaselines
    }
    @IBAction func minimumScaleFactorSlider(_ sender: UISlider) {
        info.minimumScaleFactor = .init(sender.value)
    }
    @IBAction func allowsDefaultTighteningForTruncationSwitchAction(_ sender: UISwitch) {
        info.allowsDefaultTighteningForTruncation = sender.isOn
    }
    
    @IBAction func lineSpacingSliderAction(_ sender: UISlider) {
        info.lineSpacing = .init(sender.value)
    }
    @IBAction func lineHeightMultipleSliderAction(_ sender: UISlider) {
        info.lineHeightMultiple = .init(sender.value)
    }
    @IBAction func minimumLineHeightSliderAction(_ sender: UISlider) {
        info.minimumLineHeight = .init(sender.value)
    }
    @IBAction func maximumLineHeightSliderAction(_ sender: UISlider) {
        info.maximumLineHeight = .init(sender.value)
    }
    @IBAction func paragraphSpacingSliderAction(_ sender: UISlider) {
        info.paragraphSpacing = .init(sender.value)
    }
    @IBAction func paragraphSpacingBeforeSliderAction(_ sender: UISlider) {
        info.paragraphSpacingBefore = .init(sender.value)
    }
    @IBAction func firstLineHeadIndentSliderAction(_ sender: UISlider) {
        info.firstLineHeadIndent = .init(sender.value)
    }
    @IBAction func headIndentSliderAction(_ sender: UISlider) {
        info.headIndent = .init(sender.value)
    }
    @IBAction func tailIndentSliderAction(_ sender: UISlider) {
        info.tailIndent = .init(sender.value)
    }
}

extension DebugLabelViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = (scrollView.contentOffset.x + scrollView.bounds.width * 0.5).rounded(.down)
        container.set(page: .init(offset / scrollView.bounds.width), scroll: false)
    }
}
