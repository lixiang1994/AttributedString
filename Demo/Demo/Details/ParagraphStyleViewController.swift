//
//  ParagraphStyleViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class ParagraphStyleViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        \(
        """
        lineSpacing: 10, lineSpacing: 10
        lineSpacing: 10, lineSpacing: 10
        lineSpacing: 10
        """, .paragraph(.lineSpacing(10))
        )
        
        ------------------------
        
        \("alignment: center", .paragraph(.alignment(.center)))
        
        ------------------------
        
        \(
        """
        firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20
        """, .paragraph(.firstLineHeadIndent(20))
        )
        
        ------------------------
        
        \(
        """
        headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20
        """, .paragraph(.headIndent(20))
        )
        
        ------------------------
        
        \(
        """
        baseWritingDirection: rightToLeft
        """, .paragraph(.baseWritingDirection(.rightToLeft))
        )
        
        """
    }
}
