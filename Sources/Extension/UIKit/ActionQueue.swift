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
    
    private var lock: Int = 0
    
    func next(_ lock: Int) {
        self.lock = lock
        switch lock {
        case 1:
            guard let handle = action else { return }
            handle()
            next(0)
            
        default:
            action = nil
        }
    }
    
    func began(_ handle: Handle) {
        handle()
        next(1)
    }
    
    func action(_ handle: @escaping Handle) {
        if lock == 1 {
            handle()
            
        } else {
            action = handle
        }
    }
    
    func ended(_ handle: Handle) {
        handle()
        next(0)
    }
}
