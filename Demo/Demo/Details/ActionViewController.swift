//
//  ActionViewController.swift
//  Demo
//
//  Created by Lee on 2020/6/3.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class ActionViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func click(_ action: AttributedString.Action) {
            switch action.content {
            case .string(let value):
                print("点击了文本: \n\(value) \nrange: \(action.range)")
                
            case .attachment(let value):
                print("点击了附件: \n\(value) \nrange: \(action.range)")
            }
        }
        
        let a: AttributedString = .init("123", .action({ }))
        let b: AttributedString = .init(<#T##string: AttributedString##AttributedString#>, <#T##attributes: AttributedString.Attribute...##AttributedString.Attribute#>)
        
        label.attributed.text = """
        This is \("Label", .font(.systemFont(ofSize: 50)), .action(click))
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 100, height: 100))), action: click) -> Displayed in custom size.
        """
        
        textView.attributed.text = """
        This is \("TextView", .font(.systemFont(ofSize: 20)), .action(click))
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 100, height: 100))), action: click) -> Displayed in custom size.
        """
    }
}
