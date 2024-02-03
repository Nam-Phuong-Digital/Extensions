//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation

public class AsyncBlockOperation: BlockOperation {
    
    public typealias AsyncBlock = (AsyncBlockOperation) -> Void
    
    public var block: AsyncBlock?
    
    public init(block: @escaping AsyncBlock) {
        super.init()
        self.block = block
    }
    
    public override func start() {
        isExecuting = true
        if let executingBlock = self.block {
            executingBlock(self)
        } else {
            complete()
        }
    }
    
    public func complete() {
        isExecuting = false
        isFinished = true
    }
    
    private var _executing: Bool = false
    public override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                if self.responds(to: #selector(self.willChangeValue(forKey:))) {
                    willChangeValue(forKey: "isExecuting")
                }
                _executing = newValue
                if self.responds(to: #selector(self.didChangeValue(forKey:))) {
                    didChangeValue(forKey: "isExecuting")
                }
            }
        }
    }
    
    private var _finished: Bool = false;
    public override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
}

public extension OperationQueue {
    
    func addOperationWithAsyncBlock(block: AsyncBlockOperation) {
        self.addOperation(block)
    }
}
