//
//  FontViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit
import AttributedString

class FontViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.attributed.string = """
        
        \("fontSize: 13", .font(.systemFont(ofSize: 13)))

        \("fontSize: 20", .font(.systemFont(ofSize: 20)))
        
        \("fontSize: 22 weight: semibold", .font(.systemFont(ofSize: 22, weight: .semibold)))
        
        """
    }
}
