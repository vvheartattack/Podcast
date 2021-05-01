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
        print("Database Path: \(databasePath)")
    }
    
    func createSubscribedPodcastTable() {
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS subscribed_podcast (
                        track_id INTEGER PRIMARY KEY NOT NULL,
                        track_name TEXT,
                        artwork_url TEXT,
                        track_count INTEGER,
                        artist_name TEXT,
                        feed_url TEXT
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
    
    func save<T: PersistableRecord>(_ data: T) {
        do {
            try dbQueue.write { db in
                try data.save(db)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchAll<T: TableRecord & FetchableRecord>(_ type: T.Type) -> [T]? {
        do {
            return try dbQueue.read { db in
                try type.fetchAll(db)
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteSubcribedPodcast<T: PersistableRecord>(_ data: T) {
        do {
             try dbQueue.write { db in
                try data.delete(db)
            }
        } catch {
            print(error)
        }
    }
    
//    func fetchOne<T: FetchableRecord & TableRecord>(_ type: T.Type, podcast: Podcast) -> T? {
//        do {
//            return try dbQueue.read { db in
//                try db.filter(Column("tack_id" == )
//                                .fetchCount(db)
//            }
//        }
//    }
    
//    func fetchSubcribedPodcastsCount<T: PersistableRecord>(_ type: T.Type) -> Int {
//        do {
//            return  try dbQueue.read { db in
//                try type.fetchCount(db)
//                
//            }
//        } catch {
//            print(error)
//        }
//    }
    
    
}
