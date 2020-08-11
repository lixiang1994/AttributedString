//
//  Debug.swift
//  Demo
//
//  Created by Lee on 2020/8/10.
//  Copyright © 2020 LEE. All rights reserved.
//

import UIKit

enum Debug {
    
}

extension Debug {
    
    struct Label: Codable {
        // size
        var width: CGFloat?
        var height: CGFloat?
        
        // normal
        var font: UIFont?
        var numberOfLines: Int?
        var textAlignment: NSTextAlignment?
        var lineBreakMode: NSLineBreakMode?
        var adjustsFontSizeToFitWidth: Bool?
        var baselineAdjustment: UIBaselineAdjustment?
        var minimumScaleFactor: CGFloat?
        var allowsDefaultTighteningForTruncation: Bool?
        
        // paragraphs
        var lineSpacing: CGFloat?
        var lineHeightMultiple: CGFloat?
        
        init() {
            font = .systemFont(ofSize: 17.0)
        }
        
        enum CodingKeys: String, CodingKey {
            case width
            case height
            case font
            case numberOfLines
            case textAlignment
            case lineBreakMode
            case adjustsFontSizeToFitWidth
            case baselineAdjustment
            case minimumScaleFactor
            case allowsDefaultTighteningForTruncation
            case lineSpacing
            case lineHeightMultiple
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.width = try container.decodeIfPresent(CGFloat.self, forKey: .width)
            self.height = try container.decodeIfPresent(CGFloat.self, forKey: .height)
            
            let fontDescriptorData = try container.decodeIfPresent(Data.self, forKey: .font)
            if let descriptor = fontDescriptorData?.map() {
                self.font = UIFont(descriptor: descriptor, size: 0)
            }
            
            self.numberOfLines = try container.decodeIfPresent(Int.self, forKey: .numberOfLines)
            
            if let value = try container.decodeIfPresent(Int.self, forKey: .textAlignment) {
                self.textAlignment = NSTextAlignment(rawValue: value)
            }
            
            if let value = try container.decodeIfPresent(Int.self, forKey: .lineBreakMode) {
                self.lineBreakMode = NSLineBreakMode(rawValue: value)
            }
            
            self.adjustsFontSizeToFitWidth = try container.decodeIfPresent(Bool.self, forKey: .adjustsFontSizeToFitWidth)
            
            if let value = try container.decodeIfPresent(Int.self, forKey: .baselineAdjustment) {
                self.baselineAdjustment = UIBaselineAdjustment(rawValue: value)
            }
            
            self.minimumScaleFactor = try container.decodeIfPresent(CGFloat.self, forKey: .minimumScaleFactor)
            
            self.allowsDefaultTighteningForTruncation = try container.decodeIfPresent(Bool.self, forKey: .allowsDefaultTighteningForTruncation)
            
            self.lineSpacing = try container.decodeIfPresent(CGFloat.self, forKey: .lineSpacing)
            
            self.lineHeightMultiple = try container.decodeIfPresent(CGFloat.self, forKey: .lineHeightMultiple)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(width, forKey: .width)
            try container.encodeIfPresent(height, forKey: .height)
            try container.encodeIfPresent(font?.fontDescriptor.data, forKey: .font)
            try container.encodeIfPresent(numberOfLines, forKey: .numberOfLines)
            try container.encodeIfPresent(textAlignment?.rawValue, forKey: .textAlignment)
            try container.encodeIfPresent(lineBreakMode?.rawValue, forKey: .lineBreakMode)
            try container.encodeIfPresent(adjustsFontSizeToFitWidth, forKey: .adjustsFontSizeToFitWidth)
            try container.encodeIfPresent(baselineAdjustment?.rawValue, forKey: .baselineAdjustment)
            try container.encodeIfPresent(minimumScaleFactor, forKey: .minimumScaleFactor)
            try container.encodeIfPresent(allowsDefaultTighteningForTruncation, forKey: .allowsDefaultTighteningForTruncation)
            try container.encodeIfPresent(lineSpacing, forKey: .lineSpacing)
            try container.encodeIfPresent(lineHeightMultiple, forKey: .lineHeightMultiple)
        }
    }
}

extension Debug.Label {
    
    static let fonts: [UIFont] = [
        .systemFont(ofSize: 17.0),
        .systemFont(ofSize: 17.0, weight: .light),
        .systemFont(ofSize: 17.0, weight: .medium),
        .systemFont(ofSize: 17.0, weight: .semibold),
        .systemFont(ofSize: 17.0, weight: .black),
        UIFont(name: "Georgia", size: 17.0) ?? .systemFont(ofSize: 17.0),
        UIFont(name: "Helvetica", size: 17.0) ?? .systemFont(ofSize: 17.0),
        UIFont(name: "Helvetica Neue", size: 17.0) ?? .systemFont(ofSize: 17.0),
        UIFont(name: "Times New Roman", size: 17.0) ?? .systemFont(ofSize: 17.0)
    ]
}

private extension Data {
    
    func map() -> UIFontDescriptor? {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: self)
        return unarchiver.decodeObject() as? UIFontDescriptor
    }
}

private extension UIFontDescriptor {
    
    var data: Data {
        let mutableData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: mutableData)
        archiver.encode(self)
        archiver.finishEncoding()
        return .init(mutableData)
    }
}
