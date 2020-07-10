//
//  AttachmentViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/19.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit
import AttributedString

class AttachmentViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建一些自定义视图控件
        let customView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
        customView.backgroundColor = .red
        
        let customImageView = UIImageView(image: #imageLiteral(resourceName: "swift-image-1"))
        customImageView.contentMode = .scaleAspectFill
        customImageView.sizeToFit()
        
        let customLabel = UILabel()
        customLabel.text = "1234567890"
        customLabel.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel.sizeToFit()
        
        func clicked() {
            // 更改自定义视图的大小 (x y 无效)
            customView.frame = .init(x: 100, y: 0, width: .random(in: 100 ... 200), height: .random(in: 100 ... 200))
            
            // 更改自定义图片视图的图片
            customImageView.image = #imageLiteral(resourceName: "swift-icon")
            customImageView.sizeToFit()
            // 更改自定义标签的文本
            customLabel.text = "45678"
            customLabel.sizeToFit()
            
            // 请主动调用刷新布局
            textView.attributed.layout()
        }
        
        textView.attributed.text = .init(
            """
            
            This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"))) -> Displayed in original size.
            
            This is a picture -> \(.image(#imageLiteral(resourceName: "swift-icon"), .custom(.center, size: .init(width: 50, height: 50)))) -> Displayed in custom size.
            
            This is the recommended size image -> \(.image(#imageLiteral(resourceName: "swift-icon"), .proposed(.center)))).
            
            -----------------------
            
            \("ViewAttachment only support UITextView (以下视图附件仅UITextView支持):", .font(.systemFont(ofSize: 24, weight: .medium)))
            
            \("Change something", .foreground(.blue), .action(clicked))
            
            aaaa\(.view(customView, .original(.center)))aaa
            
            bbbb\(.view(customLabel, .original(.origin)))bbb
            
            cccc\(.view(customImageView, .original(.origin)))ccc
            
            """,
            .font(.systemFont(ofSize: 18))
        )
    }
}
