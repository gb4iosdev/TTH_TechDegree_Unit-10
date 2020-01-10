//
//  AsyncOperation.swift
//  NASA
//
//  Created by Gavin Butler on 10-01-2020.
//  Attribution - Dennis Parussini from TTH TD Slack channel Jan 9, 2020
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is\(rawValue.capitalized)"
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        main()
        state = .executing
    }
}
