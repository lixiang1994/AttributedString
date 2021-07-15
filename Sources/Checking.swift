//
//  Checking.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/6/22.
//  Copyright © 2020 LEE. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension ASAttributedString {
        
    public enum Checking: Hashable {
        /// 自定义范围
        case range(NSRange)
        /// 正则表达式
        case regex(String)
        #if os(iOS) || os(macOS)
        /// 动作
        case action
        #endif
        #if !os(watchOS)
        /// 附件
        case attachment
        #endif
        case date
        case link
        case address
        case phoneNumber
        case transitInformation
    }
}

extension ASAttributedString.Checking {
    
    public enum Result {
        /// 自定义范围
        case range(NSAttributedString)
        /// 正则表达式
        case regex(NSAttributedString)
        #if os(iOS) || os(macOS)
        case action(ASAttributedString.Action.Result.Content)
        #endif
        #if !os(watchOS)
        case attachment(NSTextAttachment)
        #endif
        case date(Date)
        case link(URL)
        case address(Address)
        case phoneNumber(String)
        case transitInformation(TransitInformation)
    }
}

extension ASAttributedString.Checking.Result {
    
    public struct Date {
        let date: Foundation.Date?
        let duration: TimeInterval
        let timeZone: TimeZone?
    }
    
    public struct Address {
        let name: String?
        let jobTitle: String?
        let organization: String?
        let street: String?
        let city: String?
        let state: String?
        let zip: String?
        let country: String?
        let phone: String?
    }
    
    public struct TransitInformation {
        let airline: String?
        let flight: String?
    }
}

extension ASAttributedStringWrapper {
    
    public typealias Checking = ASAttributedString.Checking
}

public extension Array where Element == ASAttributedString.Checking {
    
    static var defalut: [ASAttributedString.Checking] = [.date, .link, .address, .phoneNumber, .transitInformation]
    
    static let empty: [ASAttributedString.Checking] = []
}

extension ASAttributedString {
    
    public mutating func add(attributes: [Attribute], checkings: [Checking] = .defalut) {
        guard !attributes.isEmpty, !checkings.isEmpty else { return }
        
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach { string.addAttributes(temp, range: $0.0) }
        value = string
    }
    
    public mutating func set(attributes: [Attribute], checkings: [Checking] = .defalut) {
        guard !attributes.isEmpty, !checkings.isEmpty else { return }
        
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach { string.setAttributes(temp, range: $0.0) }
        value = string
    }
}

extension ASAttributedString {
    
    /// 匹配检查 (Key 不会出现覆盖情况, 优先级 range > action > regex > other)
    /// - Parameter checkings: 检查类型
    /// - Returns: 匹配结果 (范围, 检查类型, 检查结果)
    func matching(_ checkings: [Checking]) -> [NSRange: (Checking, Checking.Result)] {
        guard !checkings.isEmpty else {
            return [:]
        }
        
        let checkings = checkings.filtered(duplication: \.self).sorted { $0.order < $1.order }
        var result: [NSRange: (Checking, Checking.Result)] = [:]
        
        func contains(_ range: NSRange) -> Bool {
            guard !result.keys.isEmpty else {
                return false
            }
            guard result[range] != nil else {
                return false
            }
            return result.keys.contains(where: { $0.overlap(range) })
        }
        
        checkings.forEach { (checking) in
            switch checking {
            case .range(let range) where !contains(range):
                let substring = value.attributedSubstring(from: range)
                result[range] = (checking, .range(substring))
                
            case .regex(let string):
                guard let regex = try? NSRegularExpression(pattern: string, options: .caseInsensitive) else { return }
                
                let matches = regex.matches(
                    in: value.string,
                    options: .init(),
                    range: .init(location: 0, length: value.length)
                )
                
                for match in matches where !contains(match.range) {
                    let substring = value.attributedSubstring(from: match.range)
                    result[match.range] = (checking, .regex(substring))
                }
            
            #if os(iOS) || os(macOS)
            case .action:
                let actions: [NSRange: ASAttributedString.Action] = value.get(.action)
                for action in actions where !contains(action.key) {
                    result[action.key] = (.action, .action(value.get(action.key).content))
                }
            #endif
                
            #if !os(watchOS)
            case .attachment:
                let attachments: [NSRange: NSTextAttachment] = value.get(.attachment)
                func allow(_ range: NSRange, _ attachment: NSTextAttachment) -> Bool {
                    #if os(iOS)
                    return !contains(range) && !(attachment is ViewAttachment)
                    #else
                    return !contains(range)
                    #endif
                }
                for attachment in attachments where allow(attachment.key, attachment.value) {
                    result[attachment.key] = (.attachment, .attachment(attachment.value))
                }
            #endif
            
            case .link:
                // 优先获取Link属性的值
                let links: [NSRange: URL] = value.get(.link)
                for link in links where !contains(link.key) {
                    result[link.key] = (.link, .link(link.value))
                }
                fallthrough
                
            case .date, .address, .phoneNumber, .transitInformation:
                guard let detector = try? NSDataDetector(types: NSTextCheckingAllTypes) else { return }
                
                let matches = detector.matches(
                    in: value.string,
                    options: .init(),
                    range: .init(location: 0, length: value.length)
                )
                
                for match in matches where !contains(match.range) {
                    guard let type = match.resultType.map() else { continue }
                    guard checkings.contains(type) else { continue }
                    guard let mapped = match.map() else { continue }
                    result[match.range] = (type, mapped)
                }
                
            default:
                break
            }
        }
        
        return result
    }
}

fileprivate extension ASAttributedString.Checking {
    
    var order: Int {
        switch self {
        case .range:    return 0
        case .regex:    return 1
        #if os(iOS) || os(macOS)
        case .action:   return 2
        #endif
        default:        return 3
        }
    }
}

fileprivate extension ASAttributedString.Checking {
    
    func map() -> NSTextCheckingResult.CheckingType? {
        switch self {
        case .date:
            return .date
        
        case .link:
            return .link
        
        case .address:
            return .address
            
        case .phoneNumber:
            return .phoneNumber
            
        case .transitInformation:
            return .transitInformation
            
        default:
            return nil
        }
    }
}

fileprivate extension NSTextCheckingResult.CheckingType {
    
    func map() -> ASAttributedString.Checking? {
        switch self {
        case .date:
            return .date
        
        case .link:
            return .link
        
        case .address:
            return .address
            
        case .phoneNumber:
            return .phoneNumber
            
        case .transitInformation:
            return .transitInformation
            
        default:
            return nil
        }
    }
}

fileprivate extension NSTextCheckingResult {
    
    func map() -> ASAttributedString.Checking.Result? {
        switch resultType {
        case .date:
            return .date(
                .init(
                    date: date,
                    duration: duration,
                    timeZone: timeZone
                )
            )
        
        case .link:
            guard let url = url else { return nil }
            return .link(url)
        
        case .address:
            guard let components = addressComponents else { return nil }
            return .address(
                .init(
                    name: components[.name],
                    jobTitle: components[.jobTitle],
                    organization: components[.organization],
                    street: components[.street],
                    city: components[.city],
                    state: components[.state],
                    zip: components[.zip],
                    country: components[.country],
                    phone: components[.phone]
                )
            )
            
        case .phoneNumber:
            guard let number = phoneNumber else { return nil }
            return .phoneNumber(number)
            
        case .transitInformation:
            guard let components = components else { return nil }
            return .transitInformation(
                .init(
                    airline: components[.airline],
                    flight: components[.flight]
                )
            )
            
        default:
            return nil
        }
    }
}

fileprivate extension NSRange {
    
    func overlap(_ other: NSRange) -> Bool {
        guard
            let lhs = Range(self),
            let rhs = Range(other) else {
            return false
        }
        return lhs.overlaps(rhs)
    }
}
