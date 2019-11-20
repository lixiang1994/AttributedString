//
//  UnderlineViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class UnderlineViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.attributedString = """
        
        underline: none
        
        \("underline: single", .underline(.single))

        \("underline: thick", .underline(.thick))
        
        \("underline: double", .underline(.double))
        
        \("underline: byWord", .underline(.byWord))
        
        \("underline: patternDot thick", .underline([.patternDot, .thick]))
        
        \("underline: patternDash thick", .underline([.patternDash, .thick]))
        
        \("underline: patternDashDot thick", .underline([.patternDashDot, .thick]))
        
        \("underline: patternDashDotDot thick", .underline([.patternDashDotDot, .thick]))
        
        \("underline: 1", .underline(.init(rawValue: 1)))
        
        \("underline: 2", .underline(.init(rawValue: 2)))
        
        \("underline: 3", .underline(.init(rawValue: 3)))
        
        \("underline: 4", .underline(.init(rawValue: 4)))
        
        \("underline: 5", .underline(.init(rawValue: 5)))
        
        \("underline: thick color: .lightGray", .underline([.patternDot, .thick], color: .lightGray))
        
        \("underline: double color: .red", .underline([.patternDot, .double], color: .red))
        
        """
    }
}
