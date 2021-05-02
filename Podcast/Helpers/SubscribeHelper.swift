//
//  SubscribeHelper.swift
//  Podcast
//
//  Created by jjaychen on 2021/5/2.
//

import Foundation
import GRDB

class SubscribeHelper {
    static func subscribe(podcast: Podcast) {
        GRDBHelper.shared.save(podcast)
        NotificationCenter.default.post(name: .podcastSubscriptionUpdate, object: nil)
    }
    
    static func unsubscribe(podcast: Podcast) {
        GRDBHelper.shared.delete(podcast)
        NotificationCenter.default.post(name: .podcastSubscriptionUpdate, object: nil)
    }
    
    static func fetchAllByTimeOrder() ->[Podcast] {
        GRDBHelper.shared.fetchAll(Podcast.order(Podcast.Columns.subscribeTime).reversed())!
    }
    
    static func isSubscribed(_ podcast: Podcast) -> Bool {
        var isSubscribed = false
        do {
            // This operation is synchronized, it's safe to set `isSubscribed` inside
            // the closure.
            try GRDBHelper.shared.dbQueue.read { db in
                let matchedNumber = try Podcast.filter(Podcast.Columns.trackId == podcast.trackId).fetchCount(db)
                isSubscribed = matchedNumber != 0
            }
        } catch {
            print(error)
        }
        
        return isSubscribed
    }
}

extension Notification.Name {
    static var podcastSubscriptionUpdate = Notification.Name("PoscastSubscriptionUpdate")
}
