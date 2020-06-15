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
extension WKInterfaceTextField: AttributedStringCompatible {
    
}

@available(watchOS 6.0, *)
extension AttributedStringWrapper where Base: WKInterfaceTextField {
    
    public func set(text: AttributedString?) {
        base.setAttributedText(text?.value)
    }
    
    public func setPlaceholder(text: AttributedString?) {
        base.setAttributedPlaceholder(text?.value)
    }
}

#endif
