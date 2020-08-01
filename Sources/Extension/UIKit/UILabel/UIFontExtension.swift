//
//  UIFontExtension.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/8/1.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

private var UIFontSystemFontKey: Void?

extension UIFont {
    
    static let Patch: Void = {
        swizzleMethod(for: UIFont.self, #selector(getter: lineHeight), #selector(getter: a_lineHeight))
        swizzleMethod(for: UIFont.self, #selector(getter: descender), #selector(getter: a_descender))
        swizzleMethod(for: UIFont.self, #selector(getter: leading), #selector(getter: a_leading))
        swizzleMethod(for: UIFont.self, #selector(getter: ascender), #selector(getter: a_ascender))
        swizzleMethod(for: UIFont.self, #selector(getter: capHeight), #selector(getter: a_capHeight))
        swizzleMethod(for: UIFont.self, #selector(getter: xHeight), #selector(getter: a_xHeight))
    } ()
    
    private var systemFont: UIFont {
        return associated.get(&UIFontSystemFontKey) ?? {
            associated.set(assign: &UIFontSystemFontKey, $0); return $0
        } (UIFont.systemFont(ofSize: pointSize))
    }
    
    @objc
    var a_lineHeight: CGFloat {
        systemFont.a_lineHeight
    }
    
    @objc
    var a_descender: CGFloat {
        systemFont.a_descender
    }
    
    @objc
    var a_leading: CGFloat {
        systemFont.a_leading
    }
    
    @objc
    var a_ascender: CGFloat {
        systemFont.a_ascender
    }
    
    @objc
    var a_capHeight: CGFloat {
        systemFont.a_capHeight
    }
    
    @objc
    var a_xHeight: CGFloat {
        systemFont.a_xHeight
    }
}

#endif
