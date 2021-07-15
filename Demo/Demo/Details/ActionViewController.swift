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
        
        // 如果需要修改全局默认高亮样式 可以通过以下方式
        // Array<AttributedString.Action.Highlight>.defalut = [.foreground(<#T##value: Color##Color#>)]
        
        func clicked(_ result: ASAttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("点击了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("点击了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        func pressed(_ result: ASAttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("按住了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("按住了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        let custom = ASAttributedString.Action(.press, highlights: [.background(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), .foreground(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]) { (result) in
            switch result.content {
            case .string(let value):
                print("按住了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("按住了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        label.attributed.text = """
        This is \("Label", .font(.systemFont(ofSize: 50)), .action(clicked))
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 100, height: 100))), action: clicked) -> Displayed in custom size.
        
        This is \("Long Press", .font(.systemFont(ofSize: 30)), .action(.press, pressed))
        
        Please \("custom", .font(.systemFont(ofSize: 30)), .action(custom)).
        
        Please custom -> \(.image(#imageLiteral(resourceName: "swift-icon"), .original(.center)), action: custom).
        
        """
        
        textView.attributed.text = """
        This is \("TextView", .font(.systemFont(ofSize: 20)), .action(clicked))
        
        This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 100, height: 100))), action: clicked) -> Displayed in custom size.
        
        This is \("Long Press", .font(.systemFont(ofSize: 30)), .action(.press, pressed))
        
        Please \("custom", .font(.systemFont(ofSize: 30)), .action(custom)).
        
        Please custom -> \(.image(#imageLiteral(resourceName: "swift-icon"), .original(.center)), action: custom).
        
        """
    }
}
