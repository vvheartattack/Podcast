//
//  SubscribeHelper.swift
//  Podcast
//
//  Created by Mika on 2021/5/4.
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
    static func fetchAllSubscribedPodcastEpisodes(limit: Int = 10) -> [Episode] {
        GRDBHelper.shared.fetchAll(SubscribedPodcastEpisode.limit(limit).order(SubscribedPodcastEpisode.Columns.pubDate).reversed())?.map { $0.episdoe } ?? []
    }
    
    static func updateSubscribedPodcastEpisodes() {
        let podcasts = fetchAllByTimeOrder()
        podcasts.forEach { podcast in
            // Fetch episodes data
            NetworkManager.shared.fetchEpisodes(feedURL: podcast.feedUrl!, completionHandler: { episodes in
                episodes.map {
                    SubscribedPodcastEpisode(trackId: podcast.trackId, episdoe: $0)
                } .forEach {
                    GRDBHelper.shared.save($0)
                }
                NotificationCenter.default.post(name: .podcastSubscriptionEpisodesUpdate, object: nil)
            })
        }
    }

}

extension Notification.Name {
    static var podcastSubscriptionUpdate = Notification.Name("PoscastSubscriptionUpdate")
    static var podcastSubscriptionEpisodesUpdate = Notification.Name("SubscribedPoscastEpisodesUpdate")
}

fileprivate struct SubscribedPodcastEpisode {
    var trackId: Int
    var episdoe: Episode
}

extension SubscribedPodcastEpisode: TableRecord {
    static var databaseTableName = "subscribed_podcast_episode"
    
    // table columns of subscribed_podcast_episode
    enum Columns: String, ColumnExpression {
        case guid = "guid"
        case title = "title"
        case pubDate = "pub_date"
        case description = "description"
        case author = "author"
        case imageUrl = "image_url"
        case streamUrl = "stream_url"
        case trackId = "track_id"
    }
}

extension SubscribedPodcastEpisode: FetchableRecord {
    init(row: Row) {
        trackId = row[Columns.trackId]
        episdoe = Episode(guid: row[Columns.guid], title: row[Columns.title], pubDate: row[Columns.pubDate], description: row[Columns.description], author: row[Columns.author], imageUrl: row[Columns.imageUrl], streamUrl: row[Columns.streamUrl])
    }
}

extension SubscribedPodcastEpisode: PersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container[Columns.trackId] = trackId
        container[Columns.guid] = episdoe.guid
        container[Columns.title] = episdoe.title
        container[Columns.pubDate] = episdoe.pubDate
        container[Columns.description] = episdoe.description
        container[Columns.author] = episdoe.author
        container[Columns.imageUrl] = episdoe.imageUrl
        container[Columns.streamUrl] = episdoe.streamUrl
    }
}

