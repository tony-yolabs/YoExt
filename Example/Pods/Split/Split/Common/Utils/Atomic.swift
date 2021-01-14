//
//  Atomic.swift
//  Split
//
//  Created by Javier L. Avrudsky on 13/08/2020.
//  Copyright © 2020 Split. All rights reserved.
//

import Foundation

final class Atomic<T> {
    private let queue = DispatchQueue.global()
    private var currentValue: T
    init(_ value: T) {
        self.currentValue = value
    }

    var value: T {
        return queue.sync { self.currentValue }
    }

    func mutate(_ transformation: (inout T) -> Void) {
        queue.sync {
            transformation(&self.currentValue)
        }
    }

    func mutate(_ transformation: (T, inout T) -> Void) {
        queue.sync {
            transformation(currentValue, &self.currentValue)
        }
    }

    func getAndSet(_ newValue: T) -> T {
        var oldValue: T!
        queue.sync {
            oldValue = self.currentValue
            self.currentValue = newValue
        }
        return oldValue
    }

    func set(_ newValue: T) {
        queue.sync {
            self.currentValue = newValue
        }
    }
}

final class AtomicInt {
    private let queue = DispatchQueue.global()
    private var curValue: Int
    init(_ value: Int) {
        self.curValue = value
    }

    var value: Int {
        return queue.sync { self.curValue }
    }

    func getAndAdd(_ addValue: Int) -> Int {
        var oldValue: Int = 0
        queue.sync {
            oldValue = self.curValue
            self.curValue+=addValue
        }
        return oldValue
    }

    func mutate(_ transformation: (inout Int) -> Void) {
        queue.sync {
            transformation(&self.curValue)
        }
    }
}
