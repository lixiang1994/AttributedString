//
//  WKInterfaceLabelExtension.swift
//  AttributedString-watchOS
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(watchOS)

import WatchKit

extension WKInterfaceLabel: ASAttributedStringCompatible {
    
}

extension ASAttributedStringWrapper where Base: WKInterfaceLabel {
    
    public func set(text: ASAttributedString?) {
        base.setAttributedText(text?.value)
    }
}

#endif
