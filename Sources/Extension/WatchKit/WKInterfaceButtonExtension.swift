//
//  WKInterfaceButtonExtension.swift
//  AttributedString-watchOS
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(watchOS)

import WatchKit

extension WKInterfaceButton: ASAttributedStringCompatible {
    
}

extension ASAttributedStringWrapper where Base: WKInterfaceButton {
    
    public func set(title: ASAttributedString?) {
        base.setAttributedTitle(title?.value)
    }
}

#endif
