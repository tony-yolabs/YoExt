//
//  ReconnectBackoffCounter.swift
//  Split
//
//  Created by Javier L. Avrudsky on 13/08/2020.
//  Copyright © 2020 Split. All rights reserved.
//

import Foundation

protocol ReconnectBackoffCounter {
    func getNextRetryTime() -> Double
    func resetCounter()
}

class DefaultReconnectBackoffCounter: ReconnectBackoffCounter {
    private static let kMaxTimeLimitInSecs: Double = 1800.0 // 30 minutes (30 * 60)
    private static let kRetryExponentialBase = 2
    private let backoffBase: Int
    private var attemptCount: AtomicInt

    init(backoffBase: Int) {
        self.backoffBase = backoffBase
        self.attemptCount = AtomicInt(0)
    }

    func getNextRetryTime() -> Double {

        let base = Decimal(backoffBase * Self.kRetryExponentialBase)
        let decimalResult = pow(base, attemptCount.getAndAdd(1))

        var retryTime = Self.kMaxTimeLimitInSecs
        if !decimalResult.isNaN, decimalResult < Decimal(Self.kMaxTimeLimitInSecs) {
            retryTime = (decimalResult as NSDecimalNumber).doubleValue
        }
        return retryTime
    }

    func resetCounter() {
        attemptCount .mutate { $0 = 0 }
    }
}
