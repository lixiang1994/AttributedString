//
//  AttachmentViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.attributed.text = """
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"))) -> Displayed in original size.
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 200, height: 200)))) -> Displayed in custom size.
        
        This is the recommended size image -> \(.image(#imageLiteral(resourceName: "huaji"), .proposed(.center))).
        
        """
    }
}
