//
//  SimpleViewController.swift
//  Demo
//
//  Created by Lee on 2019/11/18.
//  Copyright © 2019 LEE. All rights reserved.
//

import UIKit
import AVKit
import AttributedString

class SimpleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var list: [Model] = []
    
    private let player = AVPlayer(
        url: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2020/10648/3/B4DA06E5-8715-4478-B755-EDFF6EC473F9/master.m3u8")!
    )
    private var playerView: VideoPlayerView = .init()
    
    private func setup() {
        tableView.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    private func setupPlayer() {
        let playerLayer = AVPlayerLayer(player: player)
        playerView = VideoPlayerView({ (view) in
            view.layer.addSublayer(playerLayer)
        })
        playerView.observe { (size, animation) in
            if let animation = animation {
                CATransaction.begin()
                CATransaction.setAnimationDuration(animation.duration)
                CATransaction.setAnimationTimingFunction(animation.timingFunction)
                playerLayer.frame = .init(origin: .zero, size: size)
                CATransaction.commit()
                
            } else {
                playerLayer.frame = .init(origin: .zero, size: size)
            }
        }
        playerView.observe { (contentMode) in
            switch contentMode {
            case .scaleToFill:
                playerLayer.videoGravity = .resize
                
            case .scaleAspectFit:
                playerLayer.videoGravity = .resizeAspect
                
            case .scaleAspectFill:
                playerLayer.videoGravity = .resizeAspectFill
                
            default:
                playerLayer.videoGravity = .resizeAspectFill
            }
        }
        playerView.contentMode = .scaleAspectFit
        playerView.backgroundColor = .black
        
        // 更新播放视图大小
        playerView.frame = .init(x: 0, y: 0, width: view.bounds.width, height: 9 / 16 * view.bounds.width)
    }
    
    private func setupAttributedString() {
        ///
        ///     .init(
        ///         """
        ///         \(.image(#imageLiteral(resourceName: "swift-icon"), .custom(size: .init(width: 64, height: 64))))
        ///         \("Swift", .font(.systemFont(ofSize: 48, weight: .semibold)))
        ///
        ///         \("The powerful programming language that is also easy to learn.", .font(.systemFont(ofSize: 32, weight: .medium)))
        ///
        ///         \("Swift is a powerful and intuitive programming language for macOS, iOS, watchOS, tvOS and beyond. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design, yet also produces software that runs lightning-fast.", .font(.systemFont(ofSize: 21)))
        ///
        ///         """,
        ///         .paragraph(.alignment(.center))
        ///     )
        ///
        ///     Equivalent
        ///
        ///     """
        ///     \(wrap:
        ///         """
        ///         \(.image(#imageLiteral(resourceName: "swift-icon"), .custom(size: .init(width: 64, height: 64))))
        ///         \("Swift", .font(.systemFont(ofSize: 48, weight: .semibold)))
        ///
        ///         \("The powerful programming language that is also easy to learn.", .font(.systemFont(ofSize: 32, weight: .medium)))
        ///
        ///         \("Swift is a powerful and intuitive programming language for macOS, iOS, watchOS, tvOS and beyond. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design, yet also produces software that runs lightning-fast.", .font(.systemFont(ofSize: 21)))
        ///
        ///         """
        ///     , .paragraph(.alignment(.center)))
        ///     """
        
        
        let array: [ASAttributedString] = [
            .init(
                """
                \(.image(#imageLiteral(resourceName: "swift-icon"), .custom(size: .init(width: 64, height: 64))))
                \("Swift", .font(.systemFont(ofSize: 48, weight: .semibold)))
                
                \("The powerful programming language that is also easy to learn.", .font(.systemFont(ofSize: 32, weight: .medium)))
                
                \("Swift is a powerful and intuitive programming language for macOS, iOS, watchOS, tvOS and beyond. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design, yet also produces software that runs lightning-fast.", .font(.systemFont(ofSize: 21)))
                
                """,
                .paragraph(.alignment(.center))
            ),
            """
            \("Great First Language", .font(.systemFont(ofSize: 40, weight: .semibold)))
            
            \(
            """
            Swift can open doors to the world of coding. In fact, it was designed to be anyone’s first programming language, whether you’re still in school or exploring new career paths. For educators, Apple created free curriculum to teach Swift both in and out of the classroom. First-time coders can download Swift Playgrounds—an app for iPad that makes getting started with Swift code interactive and fun.
            """, .font(.systemFont(ofSize: 17))
            )
            
            \(.image(#imageLiteral(resourceName: "swift-image-1")))
            """,
            """
            \("Unsafe Swift", .font(.systemFont(ofSize: 40, weight: .semibold)))
            
            \(
            """
            What exactly makes code “unsafe”? Join the Swift team as we take a look at the programming language's safety precautions — and when you might need to reach for unsafe operations. We'll take a look at APIs that can cause unexpected states if not used correctly, and how you can write code more specifically to avoid undefined behavior. Learn how to work with C APIs that use pointers and the steps to take when you want to use Swift's unsafe pointer APIs. To get the most out of this session, you should have some familiarity with Swift and the C programming language. And for more information on working with pointers, check out \"Safely Manage Pointers in Swift\".
            """, .font(.systemFont(ofSize: 17))
            )
            
            \(.view(playerView))
            
            That's cool! 😎
            """,
            """
            \("Features:", .font(.systemFont(ofSize: 30, weight: .semibold)))
            \("foregroundColor", .foreground(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
            \("backgroundColor", .background(#colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)))
            \("font", .font(.systemFont(ofSize: 18, weight: .semibold)))
            \("link", .link("https://www.apple.com/"))
            \("kern", .kern(5))
            \("ligature", .ligature(true))
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
            
            
            \("Paragraph:", .font(.systemFont(ofSize: 30, weight: .semibold)))
            \("alignment:center\nlineSpacing:10", .paragraph(.lineSpacing(10), .alignment(.center)))
            
            
            
            \("Wrap:", .font(.systemFont(ofSize: 30, weight: .semibold)))
            -----------
            \(wrap: .embedding(
                """
                Embedding
                
                fontSize: 16
                This is attributed text -> \("fontSize: 30", .font(.systemFont(ofSize: 30)), .foreground(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                This is attributed text -> \("underline: single", .underline(.single))
                \(wrap: .embedding(
                    "Test wrap color red \("fontSize: 40 medium", .font(.systemFont(ofSize: 40, weight: .medium)))"
                ), .font(.systemFont(ofSize: 20)), .foreground(.red))
                """
                ), .font(.systemFont(ofSize: 16))
            )
            -----------
            \(wrap: .override(
                """
                Override
                
                fontSize: 16
                This is attributed text -> \("fontSize: 30", .font(.systemFont(ofSize: 30)), .foreground(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                This is attributed text -> \("underline: single", .underline(.single))
                \(wrap: .override(
                    "Test wrap color red \("fontSize: 40 medium", .font(.systemFont(ofSize: 40, weight: .medium)))"
                ), .font(.systemFont(ofSize: 20)), .foreground(.red))
                """
                ), .font(.systemFont(ofSize: 16))
            )

            """
        ]
        
        let width: CGFloat
        if #available(iOS 11.0, *) {
            width = UIScreen.main.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right - 20
        } else {
            width = UIScreen.main.bounds.width - 20
        }
        list = array.map { .init($0, width: width) }
        tableView.reloadData()
    }
    
    private func reload() {
        // 获取最大宽度 重新设置内容
        let width: CGFloat
        if #available(iOS 11.0, *) {
            width = UIScreen.main.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right - 20
        } else {
            width = UIScreen.main.bounds.width - 20
        }
        // 更新播放视图大小
        playerView.frame = .init(x: 0, y: 0, width: width, height: 9 / 16 * width)
        // 更新列表数据 (重新计算高度)
        list = list.map { .init($0.content, width: width) }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupPlayer()
        setupAttributedString()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        reload()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        reload()
    }
}

extension SimpleViewController: UITableViewDelegate {
 
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

extension SimpleViewController: UITableViewDataSource {
    
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
        cell.set(model.content)
        cell.set(model.height)
        return cell
    }
}

extension SimpleViewController {
    
    struct Model {
        let content: ASAttributedString
        let height: CGFloat
        
        init(_ content: ASAttributedString, width: CGFloat) {
            self.content = content
            self.height = content.value.boundingRect(
                with: .init(
                    width: width,
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
