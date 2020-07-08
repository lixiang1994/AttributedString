//
//  VideoPlayerView.swift
//  Demo
//
//  Created by Lee on 2020/7/8.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit

class VideoPlayerView: UIView {

    private var updateContentMode: ((UIView.ContentMode) -> Void)?
    private var updateLayout: ((CGSize, CAAnimation?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(_ add: (UIView) -> Void) {
        super.init(frame: .zero)
        clipsToBounds = true
        add(self)
    }
    
    func observe(contentMode: @escaping ((UIView.ContentMode) -> Void)) {
        updateContentMode = { (mode) in
            contentMode(mode)
        }
        updateContentMode?(self.contentMode)
    }
    
    func observe(layout: @escaping ((CGSize, CAAnimation?) -> Void)) {
        updateLayout = { (size, animation) in
            layout(size, animation)
        }
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var contentMode: UIView.ContentMode {
        get {
            return super.contentMode
        }
        set {
            super.contentMode = newValue
            self.updateContentMode?(newValue)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayout?(bounds.size, layer.animation(forKey: "bounds.size"))
    }
}
