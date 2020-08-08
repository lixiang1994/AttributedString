//
//  DebugLabelView.swift
//  Demo
//
//  Created by Lee on 2020/8/7.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit

class DebugLabelView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    /// Page 1
    @IBOutlet weak var currentWidthLabel: UILabel!
    @IBOutlet weak var currentHeightLabel: UILabel!
    @IBOutlet weak var currentWidthSlider: UISlider!
    @IBOutlet weak var currentHeightSlider: UISlider!
    /// Page 2
    @IBOutlet weak var fontNameLabel: UILabel!
    @IBOutlet weak var fontNameSlider: UISlider!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeSlider: UISlider!
    /// Page 3
    @IBOutlet weak var numberOfLinesLabel: UILabel!
    @IBOutlet weak var numberOfLinesSlider: UISlider!
    @IBOutlet weak var textAlignmentLabel: UILabel!
    @IBOutlet weak var textAlignmentSlider: UISlider!
    /// Page 4
    @IBOutlet weak var lineSpacingLabel: UILabel!
    @IBOutlet weak var lineSpacingSlider: UISlider!
    @IBOutlet weak var lineHeightMultipleLabel: UILabel!
    @IBOutlet weak var lineHeightMultipleSlider: UISlider!
    
    private var labelBoundsObservation: NSKeyValueObservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
