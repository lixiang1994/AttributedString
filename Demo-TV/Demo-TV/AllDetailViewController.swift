//
//  AllDetailViewController.swift
//  Demo-TV
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class AllDetailViewController: UIViewController {

    typealias Item = AllTableViewController.Item
    
    @IBOutlet weak var tableView: UITableView!

    private var list: [NSAttributedString] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func set(item: Item) {
        list = [
            ASAttributedString(item.content, .font(.systemFont(ofSize: 38))).value,
            .init(string: item.code)
        ]

        tableView.reloadData()
    }
}

extension AllDetailViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension AllDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DetailCell",
            for: indexPath
        ) as! DetailCell
        cell.set(list[indexPath.row])
        cell.set(indexPath.row)
        return cell
    }
}

class DetailCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func set(_ text: NSAttributedString) {
        label.attributedText = text
    }
    
    func set(_ index: Int) {
        switch index {
        case 0:
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        case 1:
            label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            label.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            
        default: break
        }
    }
}
