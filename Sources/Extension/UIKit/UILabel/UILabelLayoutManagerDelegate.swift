//
//  UILabelLayoutManagerDelegate.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/8/1.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

class UILabelLayoutManagerDelegate: NSObject, NSLayoutManagerDelegate {
    
    static let shared = UILabelLayoutManagerDelegate()
    
    func layoutManager(_ layoutManager: NSLayoutManager,
                       shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>,
                       lineFragmentUsedRect: UnsafeMutablePointer<CGRect>,
                       baselineOffset: UnsafeMutablePointer<CGFloat>,
                       in textContainer: NSTextContainer,
                       forGlyphRange glyphRange: NSRange) -> Bool {
        
        guard let textStorage = layoutManager.textStorage else {
            return false
        }
        // 获取当前所有属性
        let attributes = getAttributes(layoutManager, with: textStorage, for: glyphRange)
        guard !attributes.contains(where: { $0.attributes[.attachment] != nil }) else {
            return false
        }
        
        // 获取行高最大的属性
        guard
            let item = getMaxAttributes(attributes),
            let font = item.attributes[.font] as? UIFont,
            let paragraph = item.attributes[.paragraphStyle] as? NSParagraphStyle else {
            return false
        }
        var rect = lineFragmentRect.pointee
        var used = lineFragmentUsedRect.pointee
        
        let defaultFont = UIFont.systemFont(ofSize: font.pointSize)
        let lineHeight = getLineHeight(defaultFont, with: paragraph)
        var baseline = lineHeight + defaultFont.descender
        rect.size.height = lineHeight
        
        // 某些字体 (比如 emoji) 的行高会比计算的大.
        // 如果设置 UsedRect 为一行的高度, 最后一行就会消失.
        // 所以只用比原有 UsedRect 高度更大的行高
        // 这可能导致 UITextView 在最后一行下面有多余的填充, 可以通过将 maxLineHeight 设置为 getLineHeight(:, with:) 计算的行高.
        used.size.height = max(lineHeight, used.height)
        
        /**
        From apple's doc:
        https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html
        In addition to returning the line fragment rectangle itself, the layout manager returns a rectangle called the used rectangle. This is the portion of the line fragment rectangle that actually contains glyphs or other marks to be drawn. By convention, both rectangles include the line fragment padding and the interline space (which is calculated from the font’s line height metrics and the paragraph’s line spacing parameters). However, the paragraph spacing (before and after) and any space added around the text, such as that caused by center-spaced text, are included only in the line fragment rectangle, and are not included in the used rectangle.
        */
                
        // 行间距
        rect.size.height += paragraph.lineSpacing
        
        // 段落间距
        if paragraph.paragraphSpacing > 0 {
            let lastIndex = layoutManager.characterIndexForGlyph(at: glyphRange.location + glyphRange.length - 1)
            let substring = textStorage.attributedSubstring(from: .init(location: lastIndex, length: 1)).string
            let isLineBreak = substring == "\n"
            rect.size.height += isLineBreak ? paragraph.paragraphSpacing : 0
        }
        
        // 段落前间距
        if glyphRange.location > 0, paragraph.paragraphSpacingBefore > 0 {
            let lastIndex = layoutManager.characterIndexForGlyph(at: glyphRange.location - 1)
            let substring = textStorage.attributedSubstring(from: .init(location: lastIndex, length: 1)).string
            let isLineBreak = substring == "\n"
            let space = isLineBreak ? paragraph.paragraphSpacingBefore : 0
            rect.size.height += space
            used.origin.y += space
            baseline += space
        }
        
        // 重新赋值最终结果
        lineFragmentRect.pointee = rect
        lineFragmentUsedRect.pointee = used
        baselineOffset.pointee = baseline
        
        return true
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 0
    }
}

extension UILabelLayoutManagerDelegate {
    
    private func getLineHeight(_ font: UIFont, with paragraph: NSParagraphStyle? = .none) -> CGFloat {
        guard let paragraph = paragraph else {
            return font.lineHeight
        }
        
        var lineHeight = font.lineHeight
        
        if paragraph.lineHeightMultiple > 0 {
            lineHeight *= paragraph.lineHeightMultiple
        }
        if paragraph.minimumLineHeight > 0 {
            lineHeight = max(paragraph.minimumLineHeight, lineHeight)
        }
        if paragraph.maximumLineHeight > 0 {
            lineHeight = min(paragraph.maximumLineHeight, lineHeight)
        }
        return lineHeight
    }
    
    private typealias Item = (range: NSRange, attributes: [NSAttributedString.Key: Any])
    
    private func getMaxAttributes(_ attributes: [Item]) -> Item? {
        return attributes.max { (l, r) -> Bool in
            guard
                let lf = l.attributes[.font] as? UIFont,
                let rf = r.attributes[.font] as? UIFont else {
                return false
            }
            
            let lp = l.attributes[.paragraphStyle] as? NSParagraphStyle
            let rp = r.attributes[.paragraphStyle] as? NSParagraphStyle
            return getLineHeight(lf, with: lp) < getLineHeight(rf, with: rp)
        }
    }
    
    private func getAttributes(_ layoutManager: NSLayoutManager, with textStorage: NSTextStorage, for glyphRange: NSRange) -> [Item] {
        var glyphRange = glyphRange
        
        // 排除换行符。系统不能用它计算直线。
        if glyphRange.length > 1 {
            let lastIndex = glyphRange.location + glyphRange.length - 1
            if layoutManager.propertyForGlyph(at: lastIndex) == .controlCharacter {
                glyphRange = NSRange(location: glyphRange.location, length: glyphRange.length - 1)
            }
        }
        
        let targetRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        var array: [(NSRange, [NSAttributedString.Key: Any])] = []
        var lastIndex = -1
        var effectiveRange = NSRange(location: targetRange.location, length: 0)
        while (effectiveRange.location + effectiveRange.length < targetRange.location + targetRange.length) {
            var current = effectiveRange.location + effectiveRange.length
            if current <= lastIndex {
                current += 1
            }
            let attributes = textStorage.attributes(at: current, effectiveRange: &effectiveRange)
            if !attributes.isEmpty {
                array.append((effectiveRange, attributes))
            }
            lastIndex = current
        }
        return array
    }
}

#endif
