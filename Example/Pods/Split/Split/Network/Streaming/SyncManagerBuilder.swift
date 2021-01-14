//
//  SyncManagerBuilder.swift
//  Split
//
//  Created by Javier L. Avrudsky on 22/09/2020.
//  Copyright © 2020 Split. All rights reserved.
//

import Foundation

class SyncManagerBuilder {

    private var userKey: String?
    private var splitConfig: SplitClientConfig?
    private var splitApiFacade: SplitApiFacade?
    private var storageContainer: SplitStorageContainer?
    private var endpointFactory: EndpointFactory?
    private var restClient: DefaultRestClient?

    func setUserKey(_ userKey: String) -> SyncManagerBuilder {
        self.userKey = userKey
        return self
    }

    func setSplitConfig(_ splitConfig: SplitClientConfig) -> SyncManagerBuilder {
        self.splitConfig = splitConfig
        return self
    }

    func setSplitApiFacade(_ apiFacade: SplitApiFacade) -> SyncManagerBuilder {
        self.splitApiFacade = apiFacade
        return self
    }

    func setStorageContainer(_ storageContainer: SplitStorageContainer) -> SyncManagerBuilder {
        self.storageContainer = storageContainer
        return self
    }

    func setEndpointFactory(_ endpointFactory: EndpointFactory) -> SyncManagerBuilder {
        self.endpointFactory = endpointFactory
        return self
    }

    func setRestClient(_ restClient: DefaultRestClient) -> SyncManagerBuilder {
        self.restClient = restClient
        return self
    }

    func build() -> SyncManager {

        guard let userKey = self.userKey,
            let config = self.splitConfig,
            let apiFacade = self.splitApiFacade,
            let restClient = self.restClient,
            let endpointFactory = self.endpointFactory,
            let storageContainer = self.storageContainer
            else {
                fatalError("Some parameter is null when creating Sync Manager")
        }

        let synchronizer = DefaultSynchronizer(splitConfig: config, splitApiFacade: apiFacade,
                                               splitStorageContainer: storageContainer)
        let sseHttpConfig = HttpSessionConfig()
        sseHttpConfig.connectionTimeOut = config.sseHttpClientConnectionTimeOut
        let sseHttpClient = apiFacade.streamingHttpClient ?? DefaultHttpClient(configuration: sseHttpConfig)
        let broadcasterChannel = DefaultPushManagerEventBroadcaster()
        let notificationManagerKeeper = DefaultNotificationManagerKeeper(broadcasterChannel: broadcasterChannel)

        let notificationProcessor =  DefaultSseNotificationProcessor(
            notificationParser: DefaultSseNotificationParser(),
            splitsUpdateWorker: SplitsUpdateWorker(synchronizer: synchronizer),
            splitKillWorker: SplitKillWorker(synchronizer: synchronizer,
                                             splitCache: storageContainer.splitsCache),
            mySegmentsUpdateWorker: MySegmentsUpdateWorker(synchronizer: synchronizer,
                                                           mySegmentsCache: storageContainer.mySegmentsCache))

        let sseHandler = DefaultSseHandler(notificationProcessor: notificationProcessor,
                                           notificationParser: DefaultSseNotificationParser(),
                                           notificationManagerKeeper: notificationManagerKeeper,
                                           broadcasterChannel: broadcasterChannel)

        let sseAuthenticator = DefaultSseAuthenticator(restClient: restClient, jwtParser: DefaultJwtTokenParser())
        let sseClient = DefaultSseClient(endpoint: endpointFactory.streamingEndpoint,
                                         httpClient: sseHttpClient, sseHandler: sseHandler)

        let pushManager = DefaultPushNotificationManager(
            userKey: userKey, sseAuthenticator: sseAuthenticator, sseClient: sseClient,
            broadcasterChannel: broadcasterChannel,
            timersManager: DefaultTimersManager())

        let sseBackoffCounter = DefaultReconnectBackoffCounter(backoffBase: config.pushRetryBackoffBase)
        let sseBackoffTimer = DefaultBackoffCounterTimer(reconnectBackoffCounter: sseBackoffCounter)

        return DefaultSyncManager(splitConfig: config, pushNotificationManager: pushManager,
                                  reconnectStreamingTimer: sseBackoffTimer,
                                  notificationHelper: DefaultNotificationHelper.instance,
                                  synchronizer: synchronizer, broadcasterChannel: broadcasterChannel)
    }
}
