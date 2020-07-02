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

import Foundation

extension AttributedString {
    
    public enum Checking: CaseIterable {
        #if os(iOS) || os(macOS)
        case action
        #endif
        case date
        case link
        case address
        case phoneNumber
        case transitInformation
    }
}

extension AttributedString.Checking {
    
    public enum Result {
        #if os(iOS) || os(macOS)
        case action
        #endif
        case date(Date)
        case link(URL)
        case address(Address)
        case phoneNumber(String)
        case transitInformation(TransitInformation)
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
    
    static var all: [AttributedString.Checking] = AttributedString.Checking.allCases
    
    static let empty: [AttributedString.Checking] = []
}

extension AttributedString {
    
    public mutating func add(attributes: [Attribute], checkings: [Checking] = .all) {
        var temp: [NSAttributedString.Key: Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach {
            string.addAttributes(temp, range: $0.0)
        }
        
        value = string
    }
}

extension AttributedString {
    
    /// 匹配检查
    /// - Parameter checkings: 检查类型
    /// - Returns: 匹配结果 (范围, 检查类型, 检查结果)
    func matching(_ checkings: [Checking]) -> [(NSRange, Checking, Checking.Result)] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingAllTypes) else { return [] }
        
        var result: [(NSRange, Checking, Checking.Result)] = []
        
        #if os(iOS) || os(macOS)
        let actions: [(NSRange, AttributedString.Action)] = value.get(.action)
        result += actions.map { ($0.0, .action, .action) }
        
        func contains(_ index: Int) -> Bool {
            // Action范围不允许 防止Action范围被拆分
            return actions.contains(where: { $0.0.contains(index) })
        }
        #endif
        
        let matches = detector.matches(
            in: value.string,
            options: .init(),
            range: .init(location: 0, length: value.length)
        )
        
        let checkings = Set(checkings)
        result += matches.compactMap {
            guard let type = $0.resultType.map() else { return nil }
            guard checkings.contains(type) else { return nil }
            #if os(iOS) || os(macOS)
            // 不包含在Action的范围内
            guard !contains($0.range.location) else { return nil }
            #endif
            
            switch type {
            case .date:
                return ($0.range, type, .date(
                    .init(
                        date: $0.date,
                        duration: $0.duration,
                        timeZone: $0.timeZone
                    )
                ))
                
            case .link:
                guard let url = $0.url else { return nil }
                return ($0.range, type, .link(url))
                
            case .address:
                guard let components = $0.addressComponents else { return nil }
                return ($0.range, type, .address(
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
                ))
                
            case .phoneNumber:
                guard let number = $0.phoneNumber else { return nil }
                return ($0.range, type, .phoneNumber(number))
                
            case .transitInformation:
                guard let components = $0.components else { return nil }
                return ($0.range, type, .transitInformation(
                    .init(
                        airline: components[.airline],
                        flight: components[.flight]
                    )
                ))
                
            default:
                return nil
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
