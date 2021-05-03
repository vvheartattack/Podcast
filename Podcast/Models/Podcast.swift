//
//  Podcast.swift
//  Podcast
//
//  Created by Mika on 2021/3/15.
//

import Foundation
import GRDB

struct Podcast: Decodable, Hashable {
    var trackId: Int
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

struct SearchResults: Decodable {
    var resultCount: Int
    var results: [Podcast]
}

extension Podcast: TableRecord {
    static var databaseTableName = "subscribed_podcast"
    
    // table columns of subscribed_podcast
    enum Columns: String, ColumnExpression {
        case trackId = "track_id"
        case trackName = "track_name"
        case artistName = "artist_name"
        case artworkUrl600 = "artwork_url"
        case trackCount = "track_count"
        case feedUrl = "feed_url"
        case subscribeTime = "subscribe_time"

    }
}

extension Podcast: FetchableRecord {
    init(row: Row) {
        trackId = row[Columns.trackId]
        trackName = row[Columns.trackName]
        artworkUrl600 = row[Columns.artworkUrl600]
        artistName = row[Columns.artistName]
        feedUrl = row[Columns.feedUrl]
        trackCount = row[Columns.trackCount]
        
    }
}

extension Podcast: PersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container[Columns.trackId] = trackId
        container[Columns.trackName] = trackName
        container[Columns.trackCount] = trackCount
        container[Columns.artworkUrl600] = artworkUrl600
        container[Columns.artistName] = artistName
        container[Columns.feedUrl] = feedUrl
    }
}

//extension Podcast: Identifiable {
//    var id: ObjectIdentifier {
//        
//    }
//    
//    
//}
