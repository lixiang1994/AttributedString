//
//  ViewController.swift
//  Demo-Mac
//
//  Created by Lee on 2019/11/18.
//  Copyright © 2019 LEE. All rights reserved.
//

import Cocoa
import AppKit
import AttributedString

class ViewController: NSViewController {

    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let array: [AttributedString] = [
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
            \("Features:", .font(.systemFont(ofSize: 30, weight: .semibold)))
            \("foregroundColor", .color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
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
                This is attributed text -> \("fontSize: 30", .font(.systemFont(ofSize: 30)), .color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                This is attributed text -> \("underline: single", .underline(.single))
                \(wrap: .embedding(
                    "Test wrap color red \("fontSize: 40 medium", .font(.systemFont(ofSize: 40, weight: .medium)))"
                ), .font(.systemFont(ofSize: 20)), .color(.red))
                """
                ), .font(.systemFont(ofSize: 16))
            )
            -----------
            \(wrap: .override(
                """
                Override
                
                fontSize: 16
                This is attributed text -> \("fontSize: 30", .font(.systemFont(ofSize: 30)), .color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                This is attributed text -> \("underline: single", .underline(.single))
                \(wrap: .override(
                    "Test wrap color red \("fontSize: 40 medium", .font(.systemFont(ofSize: 40, weight: .medium)))"
                ), .font(.systemFont(ofSize: 20)), .color(.red))
                """
                ), .font(.systemFont(ofSize: 16))
            )

            """
        ]
        
        let string = array.reduce(into: AttributedString(stringLiteral: "")) {
            $0 += $1 + "\n"
        }
        label.attributed.string = string
    }
}

