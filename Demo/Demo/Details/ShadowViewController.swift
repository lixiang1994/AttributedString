//
//  ShadowViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class ShadowViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        shadow: none
        
        \("shadow: defalut", .shadow(.init()))

        \("shadow: offset 0 radius: 4 color: nil", .shadow(.init(offset: .zero, radius: 4)))
        
        \("shadow: offset 0 radius: 4 color: .gray", .shadow(.init(offset: .zero, radius: 4, color: .gray)))
        
        \("shadow: offset 3 radius: 4 color: .gray", .shadow(.init(offset: .init(width: 0, height: 3), radius: 4, color: .gray)))
        
        \("shadow: offset 3 radius: 10 color: .gray", .shadow(.init(offset: .init(width: 0, height: 3), radius: 10, color: .gray)))
        
        \("shadow: offset 10 radius: 1 color: .gray", .shadow(.init(offset: .init(width: 0, height: 10), radius: 1, color: .gray)))
        
        \("shadow: offset 4 radius: 3 color: .red", .shadow(.init(offset: .init(width: 0, height: 4), radius: 3, color: .red)))
        
        """
    }
}
