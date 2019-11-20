//
//  StrokeViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class StrokeViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.text = """
        
        stroke: none
        
        \("stroke: 0", .stroke())

        \("stroke: 1", .stroke(1))
        
        \("stroke: 2", .stroke(2))
        
        \("stroke: 3", .stroke(3))
        
        \("stroke: 3 color: .black", .stroke(3, color: .black))
        
        \("stroke: 3 color: .blue", .stroke(3, color: .blue))
        
        \("stroke: 3 color: .red", .stroke(3, color: .red))
        
        """
    }
}
