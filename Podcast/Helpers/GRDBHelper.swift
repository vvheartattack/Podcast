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
                if !(try! db.tableExists("subscribed_podcast")) {
                    
                    try db.execute(sql: """
                        CREATE TABLE IF NOT EXISTS subscribed_podcast (
                            track_id INTEGER PRIMARY KEY NOT NULL,
                            track_name TEXT,
                            artwork_url TEXT,
                            track_count INTEGER,
                            artist_name TEXT,
                            feed_url TEXT,
                            subscribe_time DATETIME DEFAULT CURRENT_TIMESTAMP
                            )
                        """)
                    
                    let podcast1 = Podcast(trackId: 1472032462, trackName: "Nice Try", artistName: "Nice Try Podcast", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5a/c2/73/5ac2732b-39c1-7ca1-d8b4-f780aeaded23/mza_1074270643340895275.jpg/600x600bb.jpg", trackCount: 71, feedUrl: "https://nicetrypod.com/episodes/feed.xml")
                    let podcast2 = Podcast(trackId: 1512341530, trackName: "郭德纲于谦助眠相声集", artistName: "酸奶酒鬼", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/0c/71/97/0c71972e-d8e6-aa1b-e2ba-da5fed83e013/mza_1869713097538247862.jpg/600x600bb.jpg", trackCount: 11, feedUrl: "http://www.ximalaya.com/album/37742509.xml")
                    let podcast3 = Podcast(trackId: 1166949390, trackName: "日谈公园", artistName: "日谈公园", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5e/b1/fd/5eb1fd90-509a-94ce-3e23-3f46c9e520da/mza_6791329813785612578.jpg/600x600bb.jpg", trackCount: 348, feedUrl: "http://www.ximalaya.com/album/5574153.xml")
                    let podcast4 = Podcast(trackId: 1493503146, trackName: "忽左忽右", artistName: "JustPod", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/d1/89/29/d189297e-7498-54bb-5fc9-919d1dd4e702/mza_3939122817325515104.png/600x600bb.jpg", trackCount: 154, feedUrl: "https://justpodmedia.com/rss/left-right.xml")
                    let podcast5 = Podcast(trackId: 1487143507, trackName: "不合时宜", artistName: "JustPod", artworkUrl600: "https://is5-ssl.mzstatic.com/image/thumb/Podcasts114/v4/12/9b/31/129b31cc-166a-1799-7085-9e1f0fe5c215/mza_4089001267238303775.png/600x600bb.jpg", trackCount: 73, feedUrl: "https://justpodmedia.com/rss/theweirdo.xml")
                    let podcasts = [podcast1, podcast2, podcast3, podcast4, podcast5]
                    
                    podcasts.forEach { try! $0.save(db) }
                }
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    func createSubscribedPodcastEpisodesTable() {
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXISTS subscribed_podcast_episode (
                        guid TEXT PRIMARY KEY NOT NULL,
                        title TEXT,
                        pub_date TIMESTAMP,
                        description TEXT,
                        author TEXT,
                        image_url TEXT,
                        stream_url TEXT,
                        track_id INTEGER,
                        FOREIGN KEY(track_id) REFERENCES subscribed_podcast(track_id)
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
    
    func fetchAll<T: TableRecord & FetchableRecord>(_ request: QueryInterfaceRequest<T>) -> [T]? {
        do {
            return try dbQueue.read { db in
                try request.fetchAll(db)
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func delete<T: PersistableRecord>(_ data: T) {
        do {
            try dbQueue.write { db in
                try data.delete(db)
            }
        } catch {
            print(error)
        }
    }
    
}
