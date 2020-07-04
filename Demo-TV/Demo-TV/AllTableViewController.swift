//
//  AllTableViewController.swift
//  Demo-TV
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit
import AttributedString

class AllTableViewController: UITableViewController {

    private var list: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // 默认选择第一个
        tableView.selectRow(at: .init(row: 0, section: 0), animated: true, scrollPosition: .none)
        tableView(tableView, didSelectRowAt: .init(row: 0, section: 0))
    }
}

extension AllTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = list[indexPath.row]
        cell.textLabel?.text = item.title.0
        cell.detailTextLabel?.text = item.title.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let split = splitViewController,
            let detail = split.viewControllers.last as? AllDetailViewController else {
            return
        }
        detail.set(item: list[indexPath.row])
        split.showDetailViewController(detail, sender: self)
    }
}

extension AllTableViewController {
    
    struct Item {
        let title: (String, String)
        let content: AttributedString
        let code: String
    }
    
    private func loadData() {
        list = [
            .init(
                title: ("Font", "字体"),
                content: """
                
                \("fontSize: 13", .font(.systemFont(ofSize: 13)))

                \("fontSize: 20", .font(.systemFont(ofSize: 20)))
                
                \("fontSize: 22 weight: semibold", .font(.systemFont(ofSize: 22, weight: .semibold)))
                
                """,
                code: #"""
                """
                
                \("fontSize: 13", .font(.systemFont(ofSize: 13)))

                \("fontSize: 20", .font(.systemFont(ofSize: 20)))
                
                \("fontSize: 22 weight: semibold", .font(.systemFont(ofSize: 22, weight: .semibold)))
                
                """
                """#
            ),
            .init(
                title: ("ParagraphStyle", "段落样式"),
                content: """
                
                \(
                """
                lineSpacing: 10, lineSpacing: 10
                lineSpacing: 10, lineSpacing: 10
                lineSpacing: 10
                """, .paragraph(.lineSpacing(10))
                )
                
                ------------------------
                
                \("alignment: center", .paragraph(.alignment(.center)))
                
                ------------------------
                
                \(
                """
                firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20
                """, .paragraph(.firstLineHeadIndent(20))
                )
                
                ------------------------
                
                \(
                """
                headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20
                """, .paragraph(.headIndent(20))
                )
                
                ------------------------
                
                \(
                """
                baseWritingDirection: rightToLeft
                """, .paragraph(.baseWritingDirection(.rightToLeft))
                )
                
                """,
                code: #"""
                """
                
                \(
                """
                lineSpacing: 10, lineSpacing: 10
                lineSpacing: 10, lineSpacing: 10
                lineSpacing: 10
                """, .paragraph(.lineSpacing(10))
                )
                
                ------------------------
                
                \("alignment: center", .paragraph(.alignment(.center)))
                
                ------------------------
                
                \(
                """
                firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20, firstLineHeadIndent: 20
                """, .paragraph(.firstLineHeadIndent(20))
                )
                
                ------------------------
                
                \(
                """
                headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20, headIndent: 20
                """, .paragraph(.headIndent(20))
                )
                
                ------------------------
                
                \(
                """
                baseWritingDirection: rightToLeft
                """, .paragraph(.baseWritingDirection(.rightToLeft))
                )
                
                """
                """#
            ),
            .init(
                title: ("ForegroundColor", "字色"),
                content: """
                
                \("foregroundColor", .foreground(.white))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)))

                \("foregroundColor", .foreground(#colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
                
                \("foregroundColor", .foreground(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)))
                
                """,
                code: #"""
                """
                
                \("foregroundColor", .color(.white))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)))

                \("foregroundColor", .color(#colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
                
                \("foregroundColor", .color(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)))
                
                """
                """#
            ),
            .init(
                title: ("BackgroundColor", "背景色"),
                content: """
                
                \(" backgroundColor ", .background(.white))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)))

                \(" backgroundColor ", .background(#colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)))
                
                """,
                code: #"""
                """
                
                \(" backgroundColor ", .background(.white))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)))

                \(" backgroundColor ", .background(#colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)))
                
                \(" backgroundColor ", .background(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)))
                
                """
                """#
            ),
            .init(
                title: ("Ligature", "连字符"),
                content: """
                
                \("ligature: 1", .ligature(true))

                \("ligature: 0", .ligature(false))
                
                """,
                code: #"""
                """
                
                \("ligature: 1", .ligature(true))

                \("ligature: 0", .ligature(false))
                
                """
                """#
            ),
            .init(
                title: ("Kern", "字间距"),
                content: """
                
                kern: default
                
                \("kern: 0", .kern(0))

                \("kern: 2", .kern(2))
                
                \("kern: 5", .kern(5))
                
                \("kern: 10", .kern(10))
                
                """,
                code: #"""
                """
                
                kern: default
                
                \("kern: 0", .kern(0))

                \("kern: 2", .kern(2))
                
                \("kern: 5", .kern(5))
                
                \("kern: 10", .kern(10))
                
                """
                """#
            ),
            .init(
                title: ("Strikethrough", "删除线"),
                content: """
                
                strikethrough: none
                
                \("strikethrough: single", .strikethrough(.single))

                \("strikethrough: thick", .strikethrough(.thick))
                
                \("strikethrough: double", .strikethrough(.double))
                
                \("strikethrough: 1", .strikethrough(.init(rawValue: 1)))
                
                \("strikethrough: 2", .strikethrough(.init(rawValue: 2)))
                
                \("strikethrough: 3", .strikethrough(.init(rawValue: 3)))
                
                \("strikethrough: 4", .strikethrough(.init(rawValue: 4)))
                
                \("strikethrough: 5", .strikethrough(.init(rawValue: 5)))
                
                \("strikethrough: thick color: .lightGray", .strikethrough(.thick, color: .lightGray))
                
                \("strikethrough: double color: .red", .strikethrough(.double, color: .red))
                
                """,
                code: #"""
                """
                
                strikethrough: none
                
                \("strikethrough: single", .strikethrough(.single))

                \("strikethrough: thick", .strikethrough(.thick))
                
                \("strikethrough: double", .strikethrough(.double))
                
                \("strikethrough: 1", .strikethrough(.init(rawValue: 1)))
                
                \("strikethrough: 2", .strikethrough(.init(rawValue: 2)))
                
                \("strikethrough: 3", .strikethrough(.init(rawValue: 3)))
                
                \("strikethrough: 4", .strikethrough(.init(rawValue: 4)))
                
                \("strikethrough: 5", .strikethrough(.init(rawValue: 5)))
                
                \("strikethrough: thick color: .lightGray", .strikethrough(.thick, color: .lightGray))
                
                \("strikethrough: double color: .red", .strikethrough(.double, color: .red))
                
                """
                """#
            ),
            .init(
                title: ("Underline", "下划线"),
                content: """
                
                underline: none
                
                \("underline: single", .underline(.single))

                \("underline: thick", .underline(.thick))
                
                \("underline: double", .underline(.double))
                
                \("underline: byWord", .underline(.byWord))
                
                \("underline: patternDot thick", .underline([.patternDot, .thick]))
                
                \("underline: patternDash thick", .underline([.patternDash, .thick]))
                
                \("underline: patternDashDot thick", .underline([.patternDashDot, .thick]))
                
                \("underline: patternDashDotDot thick", .underline([.patternDashDotDot, .thick]))
                
                \("underline: 1", .underline(.init(rawValue: 1)))
                
                \("underline: 2", .underline(.init(rawValue: 2)))
                
                \("underline: 3", .underline(.init(rawValue: 3)))
                
                \("underline: 4", .underline(.init(rawValue: 4)))
                
                \("underline: 5", .underline(.init(rawValue: 5)))
                
                \("underline: thick color: .lightGray", .underline([.patternDot, .thick], color: .lightGray))
                
                \("underline: double color: .red", .underline([.patternDot, .double], color: .red))
                
                """,
                code: #"""
                """
                
                underline: none
                
                \("underline: single", .underline(.single))

                \("underline: thick", .underline(.thick))
                
                \("underline: double", .underline(.double))
                
                \("underline: byWord", .underline(.byWord))
                
                \("underline: patternDot thick", .underline([.patternDot, .thick]))
                
                \("underline: patternDash thick", .underline([.patternDash, .thick]))
                
                \("underline: patternDashDot thick", .underline([.patternDashDot, .thick]))
                
                \("underline: patternDashDotDot thick", .underline([.patternDashDotDot, .thick]))
                
                \("underline: 1", .underline(.init(rawValue: 1)))
                
                \("underline: 2", .underline(.init(rawValue: 2)))
                
                \("underline: 3", .underline(.init(rawValue: 3)))
                
                \("underline: 4", .underline(.init(rawValue: 4)))
                
                \("underline: 5", .underline(.init(rawValue: 5)))
                
                \("underline: thick color: .lightGray", .underline([.patternDot, .thick], color: .lightGray))
                
                \("underline: double color: .red", .underline([.patternDot, .double], color: .red))
                
                """
                """#
            ),
            .init(
                title: ("Stroke", "描边"),
                content: """
                
                stroke: none
                
                \("stroke: 0", .stroke())

                \("stroke: 1", .stroke(1))
                
                \("stroke: 2", .stroke(2))
                
                \("stroke: 3", .stroke(3))
                
                \("stroke: 3 color: .black", .stroke(3, color: .black))
                
                \("stroke: 3 color: .blue", .stroke(3, color: .blue))
                
                \("stroke: 3 color: .red", .stroke(3, color: .red))
                
                """,
                code: #"""
                """
                
                stroke: none
                
                \("stroke: 0", .stroke())

                \("stroke: 1", .stroke(1))
                
                \("stroke: 2", .stroke(2))
                
                \("stroke: 3", .stroke(3))
                
                \("stroke: 3 color: .black", .stroke(3, color: .black))
                
                \("stroke: 3 color: .blue", .stroke(3, color: .blue))
                
                \("stroke: 3 color: .red", .stroke(3, color: .red))
                
                """
                """#
            ),
            .init(
                title: ("Shadow", "阴影"),
                content: """
                
                shadow: none
                
                \("shadow: defalut", .shadow(.init()))

                \("shadow: offset 0 radius: 4 color: nil", .shadow(.init(offset: .zero, radius: 4)))
                
                \("shadow: offset 0 radius: 4 color: .gray", .shadow(.init(offset: .zero, radius: 4, color: .gray)))
                
                \("shadow: offset 3 radius: 4 color: .gray", .shadow(.init(offset: .init(width: 0, height: 3), radius: 4, color: .gray)))
                
                \("shadow: offset 3 radius: 10 color: .gray", .shadow(.init(offset: .init(width: 0, height: 3), radius: 10, color: .gray)))
                
                \("shadow: offset 10 radius: 1 color: .gray", .shadow(.init(offset: .init(width: 0, height: 10), radius: 1, color: .gray)))
                
                \("shadow: offset 4 radius: 3 color: .red", .shadow(.init(offset: .init(width: 0, height: 4), radius: 3, color: .red)))
                
                """,
                code: #"""
                """
                
                shadow: none
                
                \("shadow: defalut", .shadow(.init()))

                \("shadow: offset 0 radius: 4 color: nil", .shadow(.init(offset: .zero, radius: 4)))
                
                \("shadow: offset 0 radius: 4 color: .gray", .shadow(.init(offset: .zero, radius: 4, color: .gray)))
                
                \("shadow: offset 3 radius: 4 color: .gray", .shadow(.init(offset: .init(width: 0, height: 3), radius: 4, color: .gray)))
                
                \("shadow: offset 3 radius: 10 color: .gray", .shadow(.init(offset: .init(width: 0, height: 3), radius: 10, color: .gray)))
                
                \("shadow: offset 10 radius: 1 color: .gray", .shadow(.init(offset: .init(width: 0, height: 10), radius: 1, color: .gray)))
                
                \("shadow: offset 4 radius: 3 color: .red", .shadow(.init(offset: .init(width: 0, height: 4), radius: 3, color: .red)))
                
                """
                """#
            ),
            .init(
                title: ("TextEffect", "凸版"),
                content: """
                
                textEffect: none
                
                \("textEffect: .letterpressStyle", .textEffect(.letterpressStyle))
                
                """,
                code: #"""
                """
                
                textEffect: none
                
                \("textEffect: .letterpressStyle", .textEffect(.letterpressStyle))
                
                """
                """#
            ),
            .init(
                title: ("Attachment", "附件"),
                content: """
                
                This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"))) -> Displayed in original size.
                
                This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 200, height: 200)))) -> Displayed in custom size.
                
                This is the recommended size image -> \(.image(#imageLiteral(resourceName: "huaji"), .proposed(.center))).
                
                """,
                code: #"""
                """
                
                This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"))) -> Displayed in original size.
                
                This is a picture -> \(.image(#imageLiteral(resourceName: "huaji"), .custom(size: .init(width: 200, height: 200)))) -> Displayed in custom size.
                
                This is the recommended size image -> \(.image(#imageLiteral(resourceName: "huaji"), .proposed(.center))).
                
                """
                """#
            ),
            .init(
                title: ("Link", "URL"),
                content: """
                
                link: none
                
                \("link: https://www.apple.com", .link("https://www.apple.com"))
                
                """,
                code: #"""
                """
                
                link: none
                
                \("link: https://www.apple.com", .link("https://www.apple.com"))
                
                """
                """#
            ),
            .init(
                title: ("BaselineOffset", "基准线偏移"),
                content: """
                
                baseline offset: none
                
                ---------------------
                
                baseline \("offset: 0", .baselineOffset(0))
                
                ---------------------
                
                baseline \("offset: 1", .baselineOffset(1))
                
                ---------------------
                
                baseline \("offset: 3", .baselineOffset(3))
                
                ---------------------
                
                baseline \("offset: 5", .baselineOffset(5))
                
                ---------------------
                
                baseline \("offset: -1", .baselineOffset(-1))
                
                ---------------------
                
                baseline \("offset: -3", .baselineOffset(-3))
                
                ---------------------
                
                baseline \("offset: -5", .baselineOffset(-5))
                
                """,
                code: #"""
                """
                
                baseline offset: none
                
                ---------------------
                
                baseline \("offset: 0", .baselineOffset(0))
                
                ---------------------
                
                baseline \("offset: 1", .baselineOffset(1))
                
                ---------------------
                
                baseline \("offset: 3", .baselineOffset(3))
                
                ---------------------
                
                baseline \("offset: 5", .baselineOffset(5))
                
                ---------------------
                
                baseline \("offset: -1", .baselineOffset(-1))
                
                ---------------------
                
                baseline \("offset: -3", .baselineOffset(-3))
                
                ---------------------
                
                baseline \("offset: -5", .baselineOffset(-5))
                
                """
                """#
            ),
            .init(
                title: ("Obliqueness", "斜体"),
                content: """
                
                obliqueness: none
                
                \("obliqueness: 0.1", .obliqueness(0.1))
                
                \("obliqueness: 0.3", .obliqueness(0.3))
                
                \("obliqueness: 0.5", .obliqueness(0.5))
                
                \("obliqueness: 1.0", .obliqueness(1.0))
                
                \("obliqueness: -0.1", .obliqueness(-0.1))
                
                \("obliqueness: -0.3", .obliqueness(-0.3))
                
                \("obliqueness: -0.5", .obliqueness(-0.5))
                
                \("obliqueness: -1.0", .obliqueness(-1.0))
                
                """,
                code: #"""
                """
                
                obliqueness: none
                
                \("obliqueness: 0.1", .obliqueness(0.1))
                
                \("obliqueness: 0.3", .obliqueness(0.3))
                
                \("obliqueness: 0.5", .obliqueness(0.5))
                
                \("obliqueness: 1.0", .obliqueness(1.0))
                
                \("obliqueness: -0.1", .obliqueness(-0.1))
                
                \("obliqueness: -0.3", .obliqueness(-0.3))
                
                \("obliqueness: -0.5", .obliqueness(-0.5))
                
                \("obliqueness: -1.0", .obliqueness(-1.0))
                
                """
                """#
            ),
            .init(
                title: ("Expansion", "拉伸/压缩"),
                content: """
                
                expansion: none
                
                \("expansion: 0", .expansion(0))
                
                \("expansion: 0.1", .expansion(0.1))
                
                \("expansion: 0.3", .expansion(0.3))
                
                \("expansion: 0.5", .expansion(0.5))
                
                \("expansion: -0.1", .expansion(-0.1))
                
                \("expansion: -0.3", .expansion(-0.3))
                
                \("expansion: -0.5", .expansion(-0.5))
                
                """,
                code: #"""
                """
                
                expansion: none
                
                \("expansion: 0", .expansion(0))
                
                \("expansion: 0.1", .expansion(0.1))
                
                \("expansion: 0.3", .expansion(0.3))
                
                \("expansion: 0.5", .expansion(0.5))
                
                \("expansion: -0.1", .expansion(-0.1))
                
                \("expansion: -0.3", .expansion(-0.3))
                
                \("expansion: -0.5", .expansion(-0.5))
                
                """
                """#
            ),
            .init(
                title: ("WritingDirection", "书写方向"),
                content: """
                
                writingDirection: none
                
                \("writingDirection: LRE", .writingDirection(.LRE))
                
                \("writingDirection: RLE", .writingDirection(.RLE))
                
                \("writingDirection: LRO", .writingDirection(.LRO))
                
                \("writingDirection: RLO", .writingDirection(.RLO))
                
                """,
                code: #"""
                """
                
                writingDirection: none
                
                \("writingDirection: LRE", .writingDirection(.LRE))
                
                \("writingDirection: RLE", .writingDirection(.RLE))
                
                \("writingDirection: LRO", .writingDirection(.LRO))
                
                \("writingDirection: RLO", .writingDirection(.RLO))
                
                """
                """#
            ),
            .init(
                title: ("VerticalGlyphForm", "垂直排版"),
                content: """
                
                verticalGlyphForm: none
                
                \("verticalGlyphForm: 1", .verticalGlyphForm(true))
                
                \("verticalGlyphForm: 0", .verticalGlyphForm(false))
                
                
                \("Currently on iOS, it's always horizontal.", .foreground(.lightGray))
                
                """,
                code: #"""
                """
                
                verticalGlyphForm: none
                
                \("verticalGlyphForm: 1", .verticalGlyphForm(true))
                
                \("verticalGlyphForm: 0", .verticalGlyphForm(false))
                
                
                \("Currently on iOS, it's always horizontal.", .color(.lightGray))
                
                """
                """#
            )
        ]
        tableView.reloadData()
    }
}
