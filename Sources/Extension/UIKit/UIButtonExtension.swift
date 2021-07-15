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

extension UIButton: ASAttributedStringCompatible {
    
}

extension ASAttributedStringWrapper where Base: UIButton {

    public func setTitle(_ title: ASAttributedString?, for state: UIControl.State) {
        base.setAttributedTitle(title?.value, for: state)
    }
    
    public func title(for state: UIControl.State) -> ASAttributedString? {
        ASAttributedString(base.attributedTitle(for: state))
    }
}

#endif
