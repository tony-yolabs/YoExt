//
// ServiceEndpoints.swift
// Split
//
// Created by Javier L. Avrudsky on 13/05/2020.
// Copyright (c) 2020 Split. All rights reserved.
//

import Foundation

@objc public class ServiceEndpoints: NSObject {

    private static let kSdkEndpoint = "https://sdk.split.io/api"
    private static let kEventsEndpoint = "https://events.split.io/api"
    private static let kAuthServiceEndpoint = "https://auth.split.io/api"
    private static let kStreamingEndpoint = "https://streaming.split.io/sse"

    private (set) var sdkEndpoint: URL
    private (set) var eventsEndpoint: URL
    private (set) var authServiceEndpoint: URL
    private (set) var streamingServiceEndpoint: URL

    private init(sdkEndpoint: URL, eventsEndpoint: URL, authServiceEndpoint: URL, streamingServiceEndpoint: URL) {
        self.sdkEndpoint = sdkEndpoint
        self.eventsEndpoint = eventsEndpoint
        self.authServiceEndpoint = authServiceEndpoint
        self.streamingServiceEndpoint = streamingServiceEndpoint
    }

    @objc public static func builder() -> Builder {
        return Builder()
    }

    @objc(ServiceEndpointsBuilder)
    public class Builder: NSObject {
        private var sdkEndpoint = kSdkEndpoint
        private var eventsEndpoint = kEventsEndpoint
        private var authServiceEndpoint = kAuthServiceEndpoint
        private var streamingServiceEndpoint = kStreamingEndpoint

        ///
        /// The rest endpoint that sdk will hit for latest features and segments.
        ///
        /// @param Endpoint MUST NOT be null
        /// @return this builder
        ///

        @objc(setSdkEndpoint:)
        public func set(sdkEndpoint: String) -> Self {
            self.sdkEndpoint = sdkEndpoint
            return self
        }

        /// The rest endpoint that sdk will hit to send events and impressions
        ///
        /// @param eventsEndpoint
        /// @return this builder
        ///
        @objc(setEventsEndpoint:)
        public func set(eventsEndpoint: String) -> Self {
            self.eventsEndpoint = eventsEndpoint
            return self
        }

        /// The rest endpoint that sdk will hit to get an SSE authentication token
        /// to subscribe to SSE channels and receive update events
        ///
        /// @param authServiceEndpoint
        /// @return this builder
        ///
        @objc(setAuthServiceEndpoint:)
        public func set(authServiceEndpoint: String) -> Self {
            self.authServiceEndpoint = authServiceEndpoint
            return self
        }

        /// The rest endpoint that sdk will hit to subscribe to SSE channels
        /// and receive update events
        ///
        /// @param streamingServiceEndpoint
        /// @return this builder
        ///
        @objc(setStreamingServiceEndpoint:)
        public func set(streamingServiceEndpoint: String) -> Self {
            self.streamingServiceEndpoint = streamingServiceEndpoint
            return self
        }

        @objc public func build() -> ServiceEndpoints {
            guard let sdkUrl = URL(string: sdkEndpoint) else {
                preconditionFailure("SDK URL is not valid")
            }

            guard let eventsUrl = URL(string: eventsEndpoint) else {
                preconditionFailure("Events URL is not valid")
            }

            guard let authServiceUrl = URL(string: authServiceEndpoint) else {
                preconditionFailure("Authentication service URL is not valid")
            }

            guard let streamingServiceUrl = URL(string: streamingServiceEndpoint) else {
                preconditionFailure("Streaming URL is not valid")
            }
            return ServiceEndpoints(
                    sdkEndpoint: sdkUrl,
                    eventsEndpoint: eventsUrl,
                    authServiceEndpoint: authServiceUrl,
                    streamingServiceEndpoint: streamingServiceUrl)
        }
    }
}
