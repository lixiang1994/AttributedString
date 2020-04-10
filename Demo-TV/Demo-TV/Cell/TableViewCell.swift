//
//  TableViewCell.swift
//  Demo-TV
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
    }
    
    func set(_ string: NSAttributedString) {
        textView.attributedText = string
    }
    
    func set(_ height: CGFloat) {
        textHeight.constant = height
    }
}
