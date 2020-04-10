//
//  NSShadowExtension.swift
//  AttributedString-watchOS
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

import WatchKit

public extension NSShadow {
    
    convenience init(offset: CGSize, radius: CGFloat, color: Color? = .none) {
        self.init()
        self.shadowOffset = offset
        self.shadowBlurRadius = radius
        self.shadowColor = color
    }
}
