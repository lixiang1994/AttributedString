//
//  ExpansionViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class ExpansionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        expansion: none
        
        \("expansion: 0", .expansion(0))
        
        \("expansion: 0.1", .expansion(0.1))
        
        \("expansion: 0.3", .expansion(0.3))
        
        \("expansion: 0.5", .expansion(0.5))
        
        \("expansion: -0.1", .expansion(-0.1))
        
        \("expansion: -0.3", .expansion(-0.3))
        
        \("expansion: -0.5", .expansion(-0.5))
        
        """
    }
}
