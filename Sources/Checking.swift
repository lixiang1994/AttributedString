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

extension AttributedString {
        
    public enum Checking: Hashable {
        #if os(iOS) || os(macOS)
        case action
        #endif
        case date
        case link
        case address
        case phoneNumber
        case transitInformation
        case regex(String)
    }
}

extension AttributedString.Checking {
    
    public enum Result {
        #if os(iOS) || os(macOS)
        case action(AttributedString.Action.Result)
        #endif
        case date(Date)
        case link(URL)
        case address(Address)
        case phoneNumber(String)
        case transitInformation(TransitInformation)
        
        case regex(String)
    }
}

extension AttributedString.Checking.Result {
    
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

extension AttributedStringWrapper {
    
    public typealias Checking = AttributedString.Checking
}

public extension Array where Element == AttributedString.Checking {
    
    static var defalut: [AttributedString.Checking] = [.date, .link, .address, .phoneNumber, .transitInformation]
    
    static let empty: [AttributedString.Checking] = []
}

extension AttributedString {
    
    public mutating func add(attributes: [Attribute], checkings: [Checking] = .defalut) {
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach {
            string.addAttributes(temp, range: $0.0)
        }
        
        value = string
    }
    
    public mutating func set(attributes: [Attribute], checkings: [Checking] = .defalut) {
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach {
            string.setAttributes(temp, range: $0.0)
        }
        
        value = string
    }
}

extension AttributedString {
    
    /// 匹配检查 (Range 不会出现覆盖情况, 优先级 action > regex > other)
    /// - Parameter checkings: 检查类型
    /// - Returns: 匹配结果 (范围, 检查类型, 检查结果)
    func matching(_ checkings: [Checking]) -> [NSRange: (Checking, Checking.Result)] {
        guard !checkings.isEmpty else {
            return [:]
        }
        
        let checkings = Set(checkings)
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
        
        // Actions
        #if os(iOS) || os(macOS)
        if checkings.contains(.action) {
            let actions: [NSRange: AttributedString.Action] = value.get(.action)
            for action in actions where !contains(action.key) {
                result[action.key] = (.action, .action(value.get(action.key)))
            }
        }
        #endif
        
        // 正则表达式
        checkings.forEach { (checking) in
            guard case .regex(let string) = checking else { return }
            guard let regex = try? NSRegularExpression(pattern: string, options: .caseInsensitive) else { return }
            
            let matches = regex.matches(
                in: value.string,
                options: .init(),
                range: .init(location: 0, length: value.length)
            )
            
            for match in matches where !contains(match.range) {
                let substring = value.attributedSubstring(from: match.range)
                result[match.range] = (checking, .regex(substring.string))
            }
        }
        
        // 数据检测器
        if let detector = try? NSDataDetector(types: NSTextCheckingAllTypes) {
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
        }
        
        return result
    }
}

fileprivate extension AttributedString.Checking {
    
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
    
    func map() -> AttributedString.Checking? {
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
    
    func map() -> AttributedString.Checking.Result? {
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
