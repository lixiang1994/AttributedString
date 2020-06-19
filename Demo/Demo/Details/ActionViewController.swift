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
        
        func click(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("点击了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("点击了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        func press(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("按住了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("按住了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        let action = AttributedString.Action(.press, highlights: [.background(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]) { (result) in
            switch result.content {
            case .string(let value):
                print("点击了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("点击了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        label.attributed.text = """
        This is \("Label", .font(.systemFont(ofSize: 50)), .action(click))
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 100, height: 100))), action: click) -> Displayed in custom size.
        
        This is \("Long Press", .font(.systemFont(ofSize: 30)), .action(.press, press))
        
        Please long press -> \(.image(#imageLiteral(resourceName: "swift-icon"), .original(.center)), action: action)
        
        """
        
        textView.attributed.text = """
        This is \("TextView", .font(.systemFont(ofSize: 20)), .action(click))
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 100, height: 100))), action: click) -> Displayed in custom size.
        
        This is \("Long Press", .font(.systemFont(ofSize: 30)), .action(.press, press))
        
        Please long press -> \(.image(#imageLiteral(resourceName: "swift-icon"), .original(.center)), action: action)
        
        """
    }
}
