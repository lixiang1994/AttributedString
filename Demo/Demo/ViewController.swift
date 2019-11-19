//
//  ViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/18.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit
import AttributedString

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var list: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array: [AttributedString] = [
            """
            1. This is a \("dog 🐕", .color(.brown)).
            """,
            """
            2. This is a \("big dog 🐶", .color(.red), .font(.boldSystemFont(ofSize: 18))).
            """,
            """
            3. This is a \("kitten 🐱", .color(.red), .font(.boldSystemFont(ofSize: 8))).
            """,
            """
            4. This is a \(" monkey 🐒", .color(.white), .background(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), .font(.systemFont(ofSize: 20))).
            """,
            """
            5. This is a \(" apple 🍎", .color(.red), .kern(8), .font(.systemFont(ofSize: 20))).
            """,
            """
            6. This is a \(" gorilla 🦍", .color(.white), .background(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), .font(.systemFont(ofSize: 20))).
            """,
            """
            7. This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .original())) -> Displayed in original size.
            """,
            """
            8. This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 200, height: 200)))) -> Displayed in custom size.
            """,
            """
            9. This is the recommended size image -> \(.image(#imageLiteral(resourceName: "huaji"), .proposed(.center))).
            """,
            """
            Features:
            \("foregroundColor", .color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
            \("backgroundColor", .background(#colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)))
            \("font", .font(.systemFont(ofSize: 18, weight: .semibold)))
            \("link", .link("https://www.apple.com/"))
            \("kern", .kern(5))
            \("ligature", .ligature(0))
            \("strikethrough", .strikethrough(.single, color: .darkGray))
            \("underline", .underline(.double, color: .black))
            \("baselineOffset", .baselineOffset(5)) +5
            \("shadow", .shadow(.init(offset: .init(width: 0, height: 3), radius: 4, color: .orange)))
            \("stroke", .stroke(3.0, color: .blue))
            \("textEffect", .textEffect(.letterpressStyle))
            \("obliqueness", .obliqueness(0.3))
            \("expansion", .expansion(0.8)) 0.8
            \("writingDirection", .writingDirection(.RLO)) RLO
            \("verticalGlyphForm. Currently on iOS, it's always horizontal.", .verticalGlyphForm(true))
            
            Paragraph:
            \("alignment:center\nlineSpacing:10", .paragraph(.lineSpacing(10), .alignment(.center)))
            
            Wrap:
            -----------
            \(wrap: .embedding(
                """
                Embedding
                This is attributed text -> \("abc", .font(.systemFont(ofSize: 30)), .color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                This is attributed text -> \("xyz", .underline(.single))
                \(wrap: .embedding(
                    "Test w\("rap", .font(.systemFont(ofSize: 40, weight: .medium)))"
                ), .font(.systemFont(ofSize: 20)), .color(.red))
                """
                ), .font(.systemFont(ofSize: 16))
            )
            -----------
            \(wrap: .override(
                """
                Override
                This is attributed text -> \("abc", .font(.systemFont(ofSize: 30)), .color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                This is attributed text -> \("xyz", .underline(.single))
                \(wrap: .override(
                    "Test w\("rap", .font(.systemFont(ofSize: 40, weight: .medium)))"
                ), .font(.systemFont(ofSize: 20)), .color(.red))
                """
                ), .font(.systemFont(ofSize: 16))
            )

            """
        ]
        
        list = array.map { .init($0) }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return list[indexPath.row].height + 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableViewCell",
            for: indexPath
        ) as! TableViewCell
        let model = list[indexPath.row]
        cell.set(model.content.value)
        cell.set(model.height)
        return cell
    }
}

extension ViewController {
    
    struct Model {
        let content: AttributedString
        let height: CGFloat
        
        init(_ content: AttributedString) {
            self.content = content
            self.height = content.value.boundingRect(
                with: .init(
                    width: UIScreen.main.bounds.width - 20,
                    height: .greatestFiniteMagnitude
                ),
                options: [
                    .usesLineFragmentOrigin,
                    .usesFontLeading
                ],
                context: nil
            ).integral.size.height
        }
    }
}
