//
//  BaseOperations.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 25/11/21.
//

import Foundation

import Foundation

enum OperationState: String {
    case ready = "isReady"
    case cancelled = "isCancelled"
    case executing = "isExecuting"
    case finished = "isFinished"
}

extension NSLock {
    func criticalScope<T>(_ block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}

class BaseOperation: Operation {
    
    @objc
    class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return ["state"]
    }
    
    @objc
    class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return ["state"]
    }
    
    @objc
    class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return ["state"]
    }
    
    @objc
    class func keyPathsForValuesAffectingIsCancelled() -> Set<String> {
        return ["state"]
    }
    
    fileprivate var _state = OperationState.ready
    fileprivate let stateLock = NSLock()
    lazy var tasks: [Operation] = [Operation]()
    
    lazy var internalQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "\(self)"
        queue.isSuspended = true
        queue.qualityOfService = .default
        return queue
    }()
    
    override open var isConcurrent: Bool {
        return true
    }
    
    override open var isReady: Bool {
        return state == .ready && (super.isReady || isCancelled)
    }
    
    override open var isFinished: Bool {
        return state == .finished
    }
    
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    override open var isCancelled: Bool {
        return state == .cancelled
    }
    
    var state: OperationState {
        get {
            return stateLock.criticalScope { _state }
        }
        
        set(newState) {
            willChangeValue(forKey: "state")
            stateLock.lock()
            guard _state != .finished else {
                return
            }
            _state = newState
            stateLock.unlock()
            didChangeValue(forKey: "state")
        }
    }
    
    func finish() {
        state = .finished
    }
    
    open func execute() {
        finish()
    }
}

extension BaseOperation {
    override open func cancel() {
        if isFinished {
            return
        }
        
        tasks.forEach { $0.cancel() }
        internalQueue.cancelAllOperations()
        state = .cancelled
    }
    
    override final func main() {
        if isCancelled {
            return finish()
        }
        
        state = .executing
        execute()
        executeInternalQueue()
    }
}

extension BaseOperation {
    func addTask(task: Operation) {
        tasks.append(task)
    }
    
    func addSubOperation(operation: Operation) {
        if isCancelled { return finish() }
        internalQueue.addOperation(operation)
    }
    
    internal func executeInternalQueue() {
        if isCancelled { return finish() }
        internalQueue.isSuspended = false
    }
}
