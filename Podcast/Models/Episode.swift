//
//  Episode.swift
//  Podcast
//
//  Created by Mika on 2021/3/15.
//

import Foundation
import FeedKit

struct Episode: Hashable {
    var guid: String
    var title: String
    var pubDate: Date
    var description: String
    var author: String
    var imageUrl: String?
    var streamUrl: String
    var fileUrl: String?
    
    init(guid: String, title: String, pubDate: Date, description: String, author: String, imageUrl: String? = nil, streamUrl: String, fileUrl: String? = nil) {
        self.guid = guid
        self.title = title
        self.pubDate = pubDate
        self.description = description
        self.author = author
        self.imageUrl = imageUrl
        self.streamUrl = streamUrl
        self.fileUrl = fileUrl
    }
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? (feedItem.description ?? "")
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.guid = feedItem.guid?.value ?? UUID().uuidString
    }
    
}
