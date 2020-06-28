//
//  Checking.swift
//  AttributedString-iOS
//
//  Created by Lee on 2020/6/22.
//  Copyright © 2020 LEE. All rights reserved.
//

import Foundation

extension AttributedString {
    
    public enum Checking {
        
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

extension AttributedString {
    
    public func matching(_ checkings: [Checking]) -> [(NSRange, Checking.Result)] {
        do {
            var result: [(NSRange, Checking.Result)] = []
            
            #if os(iOS) || os(macOS)
            let actions: [(NSRange, AttributedString.Action)] = value.get(.action)
            result += actions.map({ ($0.0, .action) })
            
            func contains(_ index: Int) -> Bool {
                return actions.contains(where: { $0.0.contains(index) })
            }
            #endif
            
            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
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
                    return ($0.range, .date(
                        .init(
                            date: $0.date,
                            duration: $0.duration,
                            timeZone: $0.timeZone
                        )
                    ))
                    
                case .link:
                    guard let url = $0.url else { return nil }
                    return ($0.range, .link(url))
                    
                case .address:
                    guard let components = $0.addressComponents else { return nil }
                    return ($0.range, .address(
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
                    return ($0.range, .phoneNumber(number))
                    
                case .transitInformation:
                    guard let components = $0.components else { return nil }
                    return ($0.range, .transitInformation(
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
            
        } catch {
            return []
        }
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
        
        #if os(iOS) || os(macOS)
        case .action:
            return nil
        #endif
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
