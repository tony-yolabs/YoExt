//
//  SseNotificationProcessor.swift
//  Split
//
//  Created by Javier L. Avrudsky on 24/08/2020.
//  Copyright © 2020 Split. All rights reserved.
//

import Foundation

protocol SseNotificationProcessor {
    func process(_ notification: IncomingNotification)
}

class DefaultSseNotificationProcessor: SseNotificationProcessor {

    private let sseNotificationParser: SseNotificationParser
    private let splitsUpdateWorker: SplitsUpdateWorker
    private let mySegmentsUpdateWorker: MySegmentsUpdateWorker
    private let splitKillWorker: SplitKillWorker

    init (notificationParser: SseNotificationParser,
          splitsUpdateWorker: SplitsUpdateWorker,
          splitKillWorker: SplitKillWorker,
          mySegmentsUpdateWorker: MySegmentsUpdateWorker) {
        self.sseNotificationParser = notificationParser
        self.splitsUpdateWorker = splitsUpdateWorker
        self.mySegmentsUpdateWorker = mySegmentsUpdateWorker
        self.splitKillWorker = splitKillWorker
    }

    func process(_ notification: IncomingNotification) {

        switch notification.type {
        case .splitUpdate:
            processSplitsUpdate(notification)
        case .mySegmentsUpdate:
            processMySegmentsUpdate(notification)
        case .splitKill:
            processSplitKill(notification)
        default:
            Logger.e("Unknown notification arrived: \(notification.jsonData ?? "null" )")
        }
    }

    private func processSplitsUpdate(_ notification: IncomingNotification) {
        if let jsonData = notification.jsonData {
            do {
                try splitsUpdateWorker.process(notification:
                    sseNotificationParser.parseSplitUpdate(jsonString: jsonData))
            } catch {
                Logger.e("Error while parsing split update notification: \(error.localizedDescription)")
            }
        }
    }

    private func processSplitKill(_ notification: IncomingNotification) {
        if let jsonData = notification.jsonData {
            do {
                try splitKillWorker.process(notification:
                    sseNotificationParser.parseSplitKill(jsonString: jsonData))
            } catch {
                Logger.e("Error while parsing split kill notification: \(error.localizedDescription)")
            }
        }
    }

    private func processMySegmentsUpdate(_ notification: IncomingNotification) {
        if let jsonData = notification.jsonData {
            do {
                try mySegmentsUpdateWorker.process(notification:
                    sseNotificationParser.parseMySegmentUpdate(jsonString: jsonData))
            } catch {
                Logger.e("Error while parsing my segments update notification: \(error.localizedDescription)")
            }
        }
    }
}
