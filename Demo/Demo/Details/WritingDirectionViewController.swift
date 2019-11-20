//
//  WritingDirectionViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class WritingDirectionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.text = """
        
        writingDirection: none
        
        \("writingDirection: LRE", .writingDirection(.LRE))
        
        \("writingDirection: RLE", .writingDirection(.RLE))
        
        \("writingDirection: LRO", .writingDirection(.LRO))
        
        \("writingDirection: RLO", .writingDirection(.RLO))
        
        """
    }
}
