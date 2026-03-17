//
//  AttributedString_iOS_Tests.swift
//  AttributedString-iOS Tests
//
//  Created by Lee on 2020/4/10.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(iOS)

import XCTest
import UIKit
import CoreText

class AttributedString_iOS_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: - CoreText / UILabel Sync Tests

    /// Verify that CoreText line height matches UILabel's textRect for mixed Chinese/English text.
    /// This is the core issue: TextKit line heights diverge from UILabel, but CoreText should match.
    func testCoreTextHeightMatchesUILabelForMixedText() throws {
        let label = UILabel()
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 500)

        let text = NSMutableAttributedString(string: "我的名字叫李响Hello World mixed text测试")
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: text.length))
        label.attributedText = text
        label.layoutIfNeeded()

        let textRect = label.textRect(forBounds: label.bounds, limitedToNumberOfLines: 0)

        // CoreText layout with same text and width
        let framesetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRange(location: 0, length: 0),
            nil,
            CGSize(width: textRect.width, height: .greatestFiniteMagnitude),
            nil
        )

        // CoreText suggested height should be very close to UILabel's text rect height
        // Allow 2pt tolerance for rounding
        XCTAssertEqual(suggestedSize.height, textRect.height, accuracy: 2.0,
                       "CoreText height (\(suggestedSize.height)) should match UILabel textRect height (\(textRect.height)) for mixed Chinese/English text")
    }

    /// Verify CoreText layout produces correct line count matching UILabel with numberOfLines truncation
    func testCoreTextLineCountMatchesUILabelWithNumberOfLines() throws {
        let label = UILabel()
        label.numberOfLines = 2
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        // Long text that wraps to more than 2 lines
        let text = NSMutableAttributedString(string: "这是一段很长的中文和English混合的文本，用于测试numberOfLines截断是否正确工作。This text should wrap to many lines.")
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: text.length))
        label.attributedText = text
        label.layoutIfNeeded()

        let textRect = label.textRect(forBounds: label.bounds, limitedToNumberOfLines: 2)

        let framesetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: textRect.size))
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

        guard let lines = CTFrameGetLines(frame) as? [CTLine] else {
            XCTFail("CoreText should produce lines")
            return
        }

        // CoreText should produce at least 2 lines that fit in the textRect
        XCTAssertGreaterThanOrEqual(lines.count, 2,
                                     "CoreText should produce at least 2 lines in the available space")
    }

    /// Verify CoreText handles multiple newlines correctly with numberOfLines (the known TextKit bug)
    func testCoreTextHandlesNewlinesWithNumberOfLines() throws {
        let label = UILabel()
        label.numberOfLines = 2
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 200)

        // The exact case from the issue: abc\n\n\ndefg with numberOfLines=2
        // TextKit incorrectly shows "defg" on line 2, but UILabel/CoreText should show an empty line 2
        let text = NSMutableAttributedString(string: "abc\n\n\ndefg")
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: text.length))
        label.attributedText = text
        label.layoutIfNeeded()

        let textRect = label.textRect(forBounds: label.bounds, limitedToNumberOfLines: 2)

        let framesetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: textRect.size))
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

        guard let lines = CTFrameGetLines(frame) as? [CTLine] else {
            XCTFail("CoreText should produce lines")
            return
        }

        // With "abc\n\n\ndefg", CoreText should produce at least 3 lines (abc, empty, empty, defg)
        // When limited to 2, the first 2 lines are "abc" and empty — not "defg"
        XCTAssertGreaterThanOrEqual(lines.count, 2, "CoreText should handle newlines correctly")

        // The second line's string range should NOT start at "defg" (index 6)
        let line2Range = CTLineGetStringRange(lines[1])
        XCTAssertNotEqual(line2Range.location, 6,
                          "Second line should not jump to 'defg' — it should be the first empty newline")
        XCTAssertEqual(line2Range.location, 4,
                       "Second line should start at index 4 (after 'abc\\n')")
    }

    /// Verify CoreText hit testing produces valid character indices for mixed font text
    func testCoreTextHitTestingMixedFonts() throws {
        let text = NSMutableAttributedString(string: "Hello你好World世界")
        // Different fonts for Chinese and English
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: 5))
        text.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17), range: NSRange(location: 5, length: 2))
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 7, length: 5))
        text.addAttribute(.font, value: UIFont(name: "PingFangSC-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17), range: NSRange(location: 12, length: 2))

        let framesetter = CTFramesetterCreateWithAttributedString(text as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: CGSize(width: 300, height: 100)))
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

        guard let lines = CTFrameGetLines(frame) as? [CTLine], !lines.isEmpty else {
            XCTFail("CoreText should produce at least one line")
            return
        }

        // Test that tapping at x=0 gives the first character
        let firstCharIndex = CTLineGetStringIndexForPosition(lines[0], CGPoint(x: 1, y: 0))
        XCTAssertEqual(firstCharIndex, 0, "Tapping at start should return index 0")

        // Test that tapping past the end gives the last index
        var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
        let lineWidth = CTLineGetTypographicBounds(lines[0], &ascent, &descent, &leading)
        let lastCharIndex = CTLineGetStringIndexForPosition(lines[0], CGPoint(x: lineWidth - 1, y: 0))
        XCTAssertGreaterThan(lastCharIndex, 0, "Tapping near end should return a valid index")
    }

}

#endif
