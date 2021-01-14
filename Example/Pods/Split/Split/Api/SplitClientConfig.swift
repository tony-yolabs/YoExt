//
//  SplitConfig.swift
//  Split
//
//  Created by Brian Sztamfater on 21/9/17.
//
//

import Foundation

public typealias SplitImpressionListener = (SplitImpression) -> Void

public class SplitClientConfig: NSObject {

    ///
    /// How many milliseconds to wait before triggering a timeout event when the SDK is being initialized.
    /// Default: -1 (means no timeout)
    ///
    @objc public var sdkReadyTimeOut: Int = -1

    ///
    /// The SDK will poll Split servers for changes to feature Splits at this rate (in seconds). Default 3600 (1 hour)
    ///
    @objc public var featuresRefreshRate: Int = 3600

    ///
    /// The treatment log captures which customer saw what treatment ("on", "off", etc) at what time.
    // This log is periodically flushed back to Split servers.
    /// This configuration controls how quickly does the cache expire after a write (in seconds).
    /// Default: 1800 seconds (30 minutes)
    ///
    @objc public var impressionRefreshRate: Int = 1800

    /// Maximum number of impressions to send in one block to the server.
    /// Default 100
    @objc public var impressionsChunkSize: Int64 = 100

    ///
    /// The SDK will poll Split servers for changes to segments at this rate (in seconds).
    /// Default: 1800 seconds (30 minutes)
    ///
    @objc public var segmentsRefreshRate: Int = 1800

    ///
    /// Default queue size for impressions. Default: 30K
    ///
    @objc public var impressionsQueueSize: Int = 30000

    ///
    /// Timeout for HTTP calls in seconds. Default 30 seconds
    ///
    @objc public var connectionTimeout: Int = 30

    ///
    /// The traffic type associated with the client key.
    /// If it’s present, it’s binded to the client instance, exactly as the key.
    /// If not, we will expect the traffic type on each .track() call. This is an optional value.
    ///
    @objc public var trafficType: String?

    ///
    /// How much will we wait for the first events flush. Default: 10s.
    ///
    @objc public var eventsFirstPushWindow: Int = 10

    ///
    /// The schedule time for events flush after the first one. Default:  1800 seconds (30 minutes)
    ///
    @objc public var eventsPushRate: Int = 1800

    ///
    /// The max size of the events queue. If the queue is full, we should flush. Default: 10000
    ///
    @objc public var eventsQueueSize: Int64 = 10000

    ///
    /// The amount of events to send in a POST request. Default: 2000
    ///
    @objc public var eventsPerPush: Int = 2000

    ///
    /// The schedule time for metrics flush after the first one. Default:  1800 seconds (30 minutes)
    ///
    @objc public var metricsPushRate: Int = 1800

    ///
    /// Client API key for company. Get it from Split admin dashboard.
    ///
    @objc public var apiKey: String {
        get {
            return SecureDataStore.shared.getToken() ?? ""
        }
        set {
            SecureDataStore.shared.setToken(token: newValue)
        }

    }

    @objc public var serviceEndpoints = ServiceEndpoints.builder().build()

    ///
    /// Enables debug messages in console
    ///
    @objc public var isDebugModeEnabled: Bool {
        get {
            return Logger.shared.isDebugModeEnabled
        }
        set {
            Logger.shared.isDebugModeEnabled = newValue
        }
    }

    ///
    /// Enables verbose mode. All Sdk messages will be logged in console
    ///
    @objc public var isVerboseModeEnabled: Bool {
        get {
            return Logger.shared.isVerboseModeEnabled
        }
        set {
            Logger.shared.isVerboseModeEnabled = newValue
        }
    }

    ///
    /// The logic to handle an impression log generated during a getTreatment call
    /// - Parameters
    /// - A closure of type SplitImpressionListener, that means (SplitImpression) -> Void
    ///
    @objc public var impressionListener: SplitImpressionListener?

    ///
    /// Data folder to store localhost splits file
    /// - Default: localhost
    ///
    @objc public var localhostDataFolder: String = "localhost"

    ///
    /// Localhost splits file name
    ///
    @objc public var splitFile: String = "localhost.splits"

    ///
    /// Enable labels for impressions
    ///
    @objc public var isLabelsEnabled = true

    ///
    /// Allows  to pass a list of filters for the splits that will be downloaded
    /// Use the SyncConfig builder and Split Filter class to build correct filters
    ///
    @objc public var sync = SyncConfig.builder().build()
    /// Whether we should attempt to use streaming or not. If the variable is false,
    /// the SDK will start in polling mode and stay that way.
    /// Default: true
    ///
    @objc public var streamingEnabled = true

    ///
    /// How many seconds to wait before re attempting the whole connection flow
    /// Hard upper limit: 30 minutes (no configurable)

    /// Default: 1
    ///

    @objc public var pushRetryBackoffBase = 1 {
        didSet {
            if pushRetryBackoffBase < 1 || pushRetryBackoffBase > 1800 {
                Logger.w("pushRetryBackoffBase must be a value in seconds between 1 and 1800 (30 minutes). " +
                    "Resetting it to 1 second")
                pushRetryBackoffBase = 1
            }
        }
    }

    ///
    /// Maximum length matching / bucketing key. Internal config
    ///
    let maximumKeyLength = 250

    ///
    /// Default folder to store cached data
    ///
    let defaultDataFolder = "split_data"

    ///
    /// Max events queue memory size in bytes (5mb)
    ///
    let maxEventsQueueMemorySizeInBytes = 5242880

    ///
    /// Event without properties estimated size in bytes
    ///
    let initialEventSizeInBytes = 1024

    ///
    /// Time to consider that cache has expired
    ///
    let cacheExpirationInSeconds = 864000

    let sseHttpClientConnectionTimeOut: TimeInterval = 80

    var generalRetryBackoffBase = 1

}
