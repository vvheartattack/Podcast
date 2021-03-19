//
//  Podcast.swift
//  Podcast
//
//  Created by Mika on 2021/3/15.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
