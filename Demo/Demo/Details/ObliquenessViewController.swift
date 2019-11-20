//
//  ObliquenessViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class ObliquenessViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        obliqueness: none
        
        \("obliqueness: 0.1", .obliqueness(0.1))
        
        \("obliqueness: 0.3", .obliqueness(0.3))
        
        \("obliqueness: 0.5", .obliqueness(0.5))
        
        \("obliqueness: 1.0", .obliqueness(1.0))
        
        \("obliqueness: -0.1", .obliqueness(-0.1))
        
        \("obliqueness: -0.3", .obliqueness(-0.3))
        
        \("obliqueness: -0.5", .obliqueness(-0.5))
        
        \("obliqueness: -1.0", .obliqueness(-1.0))
        
        """
    }
}
