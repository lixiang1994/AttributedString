//
//  NSShadowExtension.swift
//  AttributedString
//
//  Created by Lee on 2020/4/8.
//  Copyright © 2020 LEE. All rights reserved.
//

import AppKit

public extension NSShadow {
    
    convenience init(offset: CGSize, radius: CGFloat, color: Color? = .none) {
        self.init()
        self.shadowOffset = offset
        self.shadowBlurRadius = radius
        self.shadowColor = color
    }
}
