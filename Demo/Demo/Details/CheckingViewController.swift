//
//  CheckingViewController.swift
//  Demo
//
//  Created by Lee on 2020/6/28.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class CheckingViewController: ViewController<CheckingView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加电话号码类型监听
        container.label.attributed.observe(.phoneNumber, with: .init(.click, highlights: [.foreground(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))], with: { (result) in
            print(result)
        }))
        // 添加默认类型监听
        container.textView.attributed.observe(highlights: [.foreground(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]) { (result) in
            print(result)
        }
        // 移除监听
        //container.textView.attributed.remove(checking: .link)
        
        func clicked(_ result: ASAttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("点击了文本: \n\(value) \nrange: \(result.range)")
                
            case .attachment(let value):
                print("点击了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        do {
            var string: ASAttributedString = """
            我的名字叫李响，我的手机号码是18611401994，我的电子邮件地址是18611401994@163.com，现在是2020/06/28 20:30。我的GitHub主页是https://github.com/lixiang1994。欢迎来Star! \("点击联系我", .action(clicked))
            """
            string.add(attributes: [.foreground(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))], checkings: [.phoneNumber])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))], checkings: [.link])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))], checkings: [.date])
            
            // 测试action
//            string.add(attributes: [.action {
//                print("11")
//            }], range: .init(location: 3, length: 6))
//            string.add(attributes: [.action {
//                print("22")
//            },.action {
//                print("33")
//            }], checkings: [.link])
            
            container.label.attributed.text = string
        }
        
        do {
            var string: ASAttributedString = """
            My name is Li Xiang, my mobile phone number is 18611401994, my email address is 18611401994@163.com, I live in No.10 Xitucheng Road, Haidian District, Beijing, China, and it is now 20:30 on June 28, 2020. My GitHub homepage is https://github.com/lixiang1994. Welcome to star me! \("Contact me", .action(clicked))
            """
            string.add(attributes: [.foreground(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))], checkings: [.address])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))], checkings: [.link, .phoneNumber])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))], checkings: [.date])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))], checkings: [.regex("Li Xiang")])
            string.add(attributes: [.font(.systemFont(ofSize: 16, weight: .medium))], checkings: [.action])
            
            // 测试action
//            string.add(attributes: [.action {
//                print("11")
//            }], range: .init(location: 3, length: 6))
//            string.add(attributes: [.action {
//                print("22")
//            },.action {
//                print("33")
//            }], checkings: [.link])
            
            container.textView.attributed.text = string
        }
        
        container.tintAdjustmentMode = .normal
    }
    
    @IBAction func changeTintAction(_ sender: Any) {
        container.tintAdjustmentMode = container.tintAdjustmentMode == .normal ? .dimmed : .normal
    }
}

class CheckingView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        let isDimmed = tintAdjustmentMode == .dimmed
        let color = isDimmed ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.attributed.text?.add(attributes: [.foreground(color)], checkings: [.action])
        textView.attributed.text.add(attributes: [.foreground(color)], checkings: [.action])
    }
}
