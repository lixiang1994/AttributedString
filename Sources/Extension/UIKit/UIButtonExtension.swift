//
//  UIButtonExtension.swift
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

extension UIButton: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UIButton {

    public func setTitle(_ title: AttributedString?, for state: UIControl.State) {
        base.setAttributedTitle(title?.value, for: state)
    }
    
    public func title(for state: UIControl.State) -> AttributedString? {
        AttributedString(base.attributedTitle(for: state))
    }
}

#endif
