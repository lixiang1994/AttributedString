//
//  ForegroundColorViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class ForegroundColorViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.string = """
        
        \("foregroundColor", .color(.white))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)))

        \("foregroundColor", .color(#colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
        
        \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)))
        
        """
    }
}
