//
//  ActionQueue.swift
//  AttributedString
//
//  Created by 李响 on 2021/10/29.
//  Copyright © 2021 LEE. All rights reserved.
//

import Foundation

/// 通常分为两种情况 began -> action -> ended / action -> began -> ended, 通过队列保证 began -> action -> ended 的执行顺序
class ActionQueue {
    
    static let main = ActionQueue()
    
    typealias Handle = () -> Void
    
    private var action: Handle?
    
    func began(_ handle: Handle) {
        handle()
    }
    
    func action(_ handle: @escaping Handle) {
        action = handle
    }
    
    func ended(_ handle: @escaping Handle) {
        action?()
        handle()
    }
    
    func cancelled(_ handle: @escaping Handle) {
        action = nil
        handle()
    }
}
