//
//  LinkViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class LinkViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.text = """
        
        link: none
        
        \("link: https://www.apple.com", .link("https://www.apple.com"))
        
        """
    }
}
