//
//  NSTextFieldExtension.swift
//  AttributedString
//
//  Created by Lee on 2020/4/8.
//  Copyright © 2020 LEE. All rights reserved.
//

import AppKit

extension NSTextField: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: NSTextField {

    public var string: AttributedString {
        get { AttributedString(base.attributedStringValue) }
        set { base.attributedStringValue = newValue.value; NSTextView }
    }
    
    public var placeholder: AttributedString? {
        get { AttributedString(base.placeholderAttributedString) }
        set { base.placeholderAttributedString = newValue?.value }
    }
}
