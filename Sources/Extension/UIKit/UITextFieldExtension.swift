//
//  UITextFieldExtension.swift
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

import UIKit

extension UITextField: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UITextField {

    public var string: AttributedString? {
        get { AttributedString(base.attributedText) }
        set { base.attributedText = newValue?.value }
    }
    
    public var placeholder: AttributedString? {
        get { AttributedString(base.attributedPlaceholder) }
        set { base.attributedPlaceholder = newValue?.value }
    }
}
