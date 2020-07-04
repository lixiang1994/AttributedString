//
//  ArrayExtension.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/7/4.
//  Copyright © 2020 LEE. All rights reserved.
//

extension Array {
    
    /// 过滤重复元素
    /// - Parameter path: KeyPath条件
    func filtered<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, e) in
            let contains = result.contains { $0[keyPath: path] == e[keyPath: path] }
            result += contains ? [] : [e]
        }
    }
    
    /// 过滤重复元素
    /// - Parameter closure: 过滤条件
    func filtered<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        return try reduce(into: [Element]()) { (result, e) in
            let contains = try result.contains { try closure($0) == closure(e) }
            result += contains ? [] : [e]
        }
    }
    
    /// 过滤重复元素
    /// - Parameter path: KeyPath条件
    @discardableResult
    mutating func filter<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        self = filtered(duplication: path)
        return self
    }
    
    /// 过滤重复元素
    /// - Parameter closure: 过滤条件
    @discardableResult
    mutating func filter<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        self = try filtered(duplication: closure)
        return self
    }
}

extension Array where Element: Equatable {
    
}
