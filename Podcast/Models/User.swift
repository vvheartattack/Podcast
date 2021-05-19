//
//  User.swift
//  Podcast
//
//  Created by Mika on 2021/5/19.
//

import Foundation

struct User: Decodable {
    var name: String
    var password:String
    var nickName: String?
}
