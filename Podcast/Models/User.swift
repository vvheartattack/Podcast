//
//  User.swift
//  Podcast
//
//  Created by Mika on 2021/5/19.
//

import Foundation
import GRDB

struct User: Decodable, Hashable {
    var name: String
    var password:String
    var nickName: String?
}

extension User: TableRecord {
    static var databaseTableName = "login_result"
    
    enum Columns: String, ColumnExpression {
        case name = "user_id"
        case password = "password"
        case nickName = "nickname"
    }
}

extension User: FetchableRecord {
    init(row: Row) {
        name = row[Columns.name]
        password = row[Columns.password]
        nickName = row[Columns.nickName]
    }
}

extension User: PersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container[Columns.name] = name
        container[Columns.password] = password
        container[Columns.nickName] = nickName
    }
}
