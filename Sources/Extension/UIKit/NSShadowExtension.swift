//
//  NSShadowExtension.swift
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

public extension NSShadow {
    
    convenience init(offset: CGSize, radius: CGFloat, color: Color? = .none) {
        self.init()
        self.shadowOffset = offset
        self.shadowBlurRadius = radius
        self.shadowColor = color
    }
}
