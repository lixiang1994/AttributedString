//
//  WKInterfaceTextFieldExtension.swift
//  AttributedString-watchOS
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(watchOS)

import WatchKit

@available(watchOS 6.0, *)
extension WKInterfaceTextField: ASAttributedStringCompatible {
    
}

@available(watchOS 6.0, *)
extension ASAttributedStringWrapper where Base: WKInterfaceTextField {
    
    public func set(text: ASAttributedString?) {
        base.setAttributedText(text?.value)
    }
    
    public func setPlaceholder(text: ASAttributedString?) {
        base.setAttributedPlaceholder(text?.value)
    }
}

#endif
