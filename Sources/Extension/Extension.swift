//
//  Extension.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by Lee on 2019/11/18.
//  Copyright © 2019 LEE. All rights reserved.
//

import Foundation

public class AttributedStringWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol AttributedStringCompatible {
    associatedtype AttributedStringCompatibleType
    var attributed: AttributedStringCompatibleType { get }
}

extension AttributedStringCompatible {
    
    public var attributed: AttributedStringWrapper<Self> {
        get { return AttributedStringWrapper(self) }
    }
}
