//
//  Comment.swift
//  Podcast
//
//  Created by Mika on 2021/5/20.
//

import Foundation
import GRDB

struct Comment: Decodable, Hashable, Encodable {
    var comment_id: UUID?
    var userName: String
    var commentContent: String
    var createTime: Date?
    var podcastTrackID: Int
    var episodeID: String
}

