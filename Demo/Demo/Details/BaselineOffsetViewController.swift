//
//  BaselineOffsetViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class BaselineOffsetViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        baseline offset: none
        
        ---------------------
        
        baseline \("offset: 0", .baselineOffset(0))
        
        ---------------------
        
        baseline \("offset: 1", .baselineOffset(1))
        
        ---------------------
        
        baseline \("offset: 3", .baselineOffset(3))
        
        ---------------------
        
        baseline \("offset: 5", .baselineOffset(5))
        
        ---------------------
        
        baseline \("offset: -1", .baselineOffset(-1))
        
        ---------------------
        
        baseline \("offset: -3", .baselineOffset(-3))
        
        ---------------------
        
        baseline \("offset: -5", .baselineOffset(-5))
        
        """
    }
}
