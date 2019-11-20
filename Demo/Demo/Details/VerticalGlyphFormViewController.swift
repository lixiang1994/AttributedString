//
//  VerticalGlyphFormViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class VerticalGlyphFormViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        verticalGlyphForm: none
        
        \("verticalGlyphForm: 1", .verticalGlyphForm(true))
        
        \("verticalGlyphForm: 0", .verticalGlyphForm(false))
        
        
        \("Currently on iOS, it's always horizontal.", .color(.lightGray))
        
        """
    }
}
