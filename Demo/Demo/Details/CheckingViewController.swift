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
        container.label.attributed.observe([.action], highlights: [.foreground(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]) { (result) in
            print(result)
        }
        // 添加全部类型监听
        container.textView.attributed.observe(highlights: [.foreground(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]) { (result) in
            print(result)
        }
        // 移除监听
        //container.textView.attributed.remove(checking: .link)
        
        do {
            var string: AttributedString = "我的名字叫李响，我的手机号码是\(18611401994, .action { print("aa") })，我的电子邮件地址是18611401994@163.com，现在是2020/06/28 20:30。我的GitHub主页是https://github.com/lixiang1994。"
            string.add(attributes: [.foreground(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))], checkings: [.address])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))], checkings: [.link])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))], checkings: [.date])
            container.label.attributed.text = string
        }
        
        do {
            var string: AttributedString = "My name is Li Xiang, my mobile phone number is 18611401994, my email address is 18611401994@163.com, I live in No.10 Xitucheng Road, Haidian District, Beijing, China, and it is now 20:30 on June 28, 2020. My GitHub homepage is https://github.com/lixiang1994."
            string.add(attributes: [.foreground(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))], checkings: [.address])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))], checkings: [.link])
            string.add(attributes: [.foreground(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))], checkings: [.date])
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
        label.attributed.text?.add(attributes: [.foreground(color)], checkings: [.phoneNumber])
        textView.attributed.text.add(attributes: [.foreground(color)], checkings: [.phoneNumber])
    }
}
