//
//  StrikethroughViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class StrikethroughViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributedString = """
        
        strikethrough: none
        
        \("strikethrough: single", .strikethrough(.single))

        \("strikethrough: thick", .strikethrough(.thick))
        
        \("strikethrough: double", .strikethrough(.double))
        
        \("strikethrough: 1", .strikethrough(.init(rawValue: 1)))
        
        \("strikethrough: 2", .strikethrough(.init(rawValue: 2)))
        
        \("strikethrough: 3", .strikethrough(.init(rawValue: 3)))
        
        \("strikethrough: 4", .strikethrough(.init(rawValue: 4)))
        
        \("strikethrough: 5", .strikethrough(.init(rawValue: 5)))
        
        \("strikethrough: thick color: .lightGray", .strikethrough(.thick, color: .lightGray))
        
        \("strikethrough: double color: .red", .strikethrough(.double, color: .red))
        
        """
    }
}
