//
//  GlobalCache.swift
//  Podcast
//
//  Created by Mika on 2021/5/19.
//

import Foundation
import UIKit
import GRDB

class GlobalCache {
    var loginResult: User?
//    var loginStatus: Bool?
    
    static let shared: GlobalCache = {
        let shared = GlobalCache()
        return shared
    }()
    
    private init() {
    }
    
    @objc func saveUserLoginResult() {
        do {
            try GRDBHelper.shared.dbQueue.write { db in
                try GlobalCache.shared.loginResult?.save(db)
            }
        } catch {
            print(error)
        }
        
    }
    
    func fetchUserLoginResult(_ type: User.Type) {
        GlobalCache.shared.loginResult =  GRDBHelper.shared.fetchAll(User.self)?.first
    }
    
}
