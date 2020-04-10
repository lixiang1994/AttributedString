//
//  AllDetailViewController.swift
//  Demo-TV
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit

class AllDetailViewController: UIViewController {

    typealias Item = AllTableViewController.Item
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var code: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 解决tvOS UITextView 无法滚动问题
        content.isSelectable = true
        content.isUserInteractionEnabled = true
        content.panGestureRecognizer.allowedTouchTypes = [.init(value: UITouch.TouchType.indirect.rawValue)]
        
        code.isSelectable = true
        code.isUserInteractionEnabled = true
        code.panGestureRecognizer.allowedTouchTypes = [.init(value: UITouch.TouchType.indirect.rawValue)]
    }

    func set(item: Item) {
        content.attributed.text = "\(wrap: .embedding(item.content), .font(.systemFont(ofSize: 38)))"
        code.text = item.code
    }
}
