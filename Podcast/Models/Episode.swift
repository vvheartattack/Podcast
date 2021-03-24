//
//  Episode.swift
//  Podcast
//
//  Created by Mika on 2021/3/15.
//

import Foundation
import FeedKit

struct Episode {
    var title: String
    var pubDate: Date
    var description: String
    var author: String
    var imageUrl: String?
    var streamUrl: String
    var fileUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? (feedItem.description ?? "")
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
}
