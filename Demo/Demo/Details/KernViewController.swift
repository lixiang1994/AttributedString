//
//  KernViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class KernViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        kern: default
        
        \("kern: 0", .kern(0))

        \("kern: 2", .kern(2))
        
        \("kern: 5", .kern(5))
        
        \("kern: 10", .kern(10))
        
        """
    }
}
