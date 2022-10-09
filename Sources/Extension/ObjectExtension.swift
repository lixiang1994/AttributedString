//
//  ObjectExtension.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2020/6/1.
//  Copyright © 2020 LEE. All rights reserved.
//

import Foundation

class AssociatedWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol AssociatedCompatible {
    associatedtype AssociatedCompatibleType
    var associated: AssociatedCompatibleType { get }
}

extension AssociatedCompatible {
    
    var associated: AssociatedWrapper<Self> {
        get { return AssociatedWrapper(self) }
    }
}

extension NSObject: AssociatedCompatible { }

extension AssociatedWrapper where Base: NSObject {
    
    enum Policy {
        case nonatomic
        case atomic
    }
    
    /// 获取关联值
    func get<T>(_ key: UnsafeRawPointer) -> T? {
        guard let value = objc_getAssociatedObject(base, key) else {
            return nil
        }
        return (value as! T)
        // 💣 Xcode 14.0 iOS12 Release Mode Crash 疑似苹果编译器漏洞
        //objc_getAssociatedObject(base, key) as? T
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_ASSIGN
    func set(assign key: UnsafeRawPointer, _ value: Any) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_RETAIN_NONATOMIC / OBJC_ASSOCIATION_RETAIN
    func set(retain key: UnsafeRawPointer, _ value: Any?, _ policy: Policy = .nonatomic) {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_COPY_NONATOMIC / OBJC_ASSOCIATION_COPY
    func set(copy key: UnsafeRawPointer, _ value: Any?, _ policy: Policy = .nonatomic) {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY)
        }
    }
}

func swizzleMethod(for aClass: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
    guard
        let originalMethod = class_getInstanceMethod(aClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector) else {
        return
    }
    
    let didAddMethod = class_addMethod(
        aClass,
        originalSelector,
        method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod)
    )
    
    if didAddMethod {
        class_replaceMethod(
            aClass,
            swizzledSelector,
            method_getImplementation(originalMethod),
            method_getTypeEncoding(originalMethod)
        )
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
