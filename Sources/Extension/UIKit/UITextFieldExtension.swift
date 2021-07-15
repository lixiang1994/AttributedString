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

#if os(iOS) || os(tvOS)

import UIKit

extension UITextField: ASAttributedStringCompatible {
    
}

extension ASAttributedStringWrapper where Base: UITextField {

    public var text: ASAttributedString? {
        get { ASAttributedString(base.attributedText) }
        set { base.attributedText = newValue?.value }
    }
    
    public var placeholder: ASAttributedString? {
        get { ASAttributedString(base.attributedPlaceholder) }
        set { base.attributedPlaceholder = newValue?.value }
    }
}

#endif
