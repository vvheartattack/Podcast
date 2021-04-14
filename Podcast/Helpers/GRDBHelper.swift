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
        
        do {
            try dbQueue.write { db in
                try db.execute(sql: """
                    CREATE TABLE IF NOT EXIST subscribed_podcast (
                        trackId TEXT PRIMARY KEY NOT NULL,
                        trackName TEXT,
                        artworkUrl TEXT,
                        trackCount Int,
                        feedUrl TEXT
                        )
                    """)
            }
        } catch {
            fatalError("\(error)")
        }
        
    }
    
}
