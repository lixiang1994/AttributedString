//
//  HighlightedViewController.swift
//  Demo
//
//  Created by Lee on 2020/6/28.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class HighlightedViewController: ViewController<HighlightedView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            var string: AttributedString = "我的名字叫李响，我的手机号码是18611401994，我的电子邮件地址是18611401994@163.com，现在是2020/06/28 20:30。我的GitHub主页是https://github.com/lixiang1994。"
            string.highlighted(checkings: [.address], [.color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))])
            string.highlighted(checkings: [.link], [.color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))])
            string.highlighted(checkings: [.date], [.color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), .font(.systemFont(ofSize: 20, weight: .medium))])
            container.label.attributed.text = string
        }
        
        do {
            var string: AttributedString = "My name is Li Xiang, my mobile phone number is 18611401994, my email address is 18611401994@163.com, I live in No.10 Xitucheng Road, Haidian District, Beijing, China, and it is now 20:30 on June 28, 2020. My GitHub homepage is https://github.com/lixiang1994."
            string.highlighted(checkings: [.address], [.color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))])
            string.highlighted(checkings: [.link], [.color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))])
            string.highlighted(checkings: [.date], [.color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1))])
            container.textView.attributed.text = string
        }
        
        container.tintAdjustmentMode = .normal
    }
    
    @IBAction func changeTintAction(_ sender: Any) {
        container.tintAdjustmentMode = container.tintAdjustmentMode == .normal ? .dimmed : .normal
    }
}

class HighlightedView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        let isDimmed = tintAdjustmentMode == .dimmed
        let color = isDimmed ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.attributed.text?.highlighted(checkings: [.phoneNumber], [.color(color)])
        textView.attributed.text.highlighted(checkings: [.phoneNumber], [.color(color)])
    }
}
