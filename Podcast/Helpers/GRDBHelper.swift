//
//  GRDBHelper.swift
//  Podcast
//
//  Created by Mika on 2021/4/14.
//

import Foundation
import GRDB

class GRDBHelper {
    let dbQueue: DatabaseQueue!
    
    static var shared = GRDBHelper()
    private init() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath = documentPath.appendingPathComponent("db.sqlite")
        dbQueue = try! DatabaseQueue(path: databasePath)
        
    }
    
    func createSubscribedPodcastTable() {
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS subscribed_podcast (
                        trackId INTEGER PRIMARY KEY NOT NULL,
                        trackName TEXT,
                        artworkUrl TEXT,
                        trackCount INTEGER,
                        feedUrl TEXT
                        )
                    """)
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    func createDownloadedEpisodeTable() {
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS downloaded_episode (
                        guid TEXt PRIMARY KEY NOT NULL,
                        title TEXT,
                        description TEXT,
                        author TEXT,
                        imageUrl TEXT,
                        downloadState TEXT
                        )
                    """)
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    func insertIntoSubscribedPodcastTable() {
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    INSERT INTO subscribed_podcast (trackId) VALUES (
                        1487143507)
                    """)
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
//    func fetchSubscribedPodcastTable() {
//        let places = try dbQueue.read { db in
//            try .fetchAll(db, sql: "SELECT * FROM subscribed_podcast")
//        }
//    }
    
}
