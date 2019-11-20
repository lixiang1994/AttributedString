//
//  TextEffectViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class TextEffectViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.attributed.string = """
        
        textEffect: none
        
        \("textEffect: .letterpressStyle", .textEffect(.letterpressStyle))
        
        """
    }
}
