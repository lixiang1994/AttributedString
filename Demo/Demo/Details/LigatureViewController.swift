//
//  LigatureViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class LigatureViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.text = """
        
        \("ligature: 1", .ligature(true))

        \("ligature: 0", .ligature(false))
        
        """
    }
}
