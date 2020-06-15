//
//  WKInterfaceButtonExtension.swift
//  AttributedString-watchOS
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(watchOS)

import WatchKit

extension WKInterfaceButton: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: WKInterfaceButton {
    
    public func set(title: AttributedString?) {
        base.setAttributedTitle(title?.value)
    }
}

#endif
