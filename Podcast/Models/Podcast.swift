//
//  Podcast.swift
//  Podcast
//
//  Created by Mika on 2021/3/15.
//

import Foundation

struct Podcast: Decodable {
    var trackId: String?
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
