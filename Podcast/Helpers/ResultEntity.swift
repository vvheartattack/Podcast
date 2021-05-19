//
//  ResultEntity.swift
//  Podcast
//
//  Created by Mika on 2021/5/19.
//

import Foundation

struct ResultEntity<T: Codable>: Codable {
    var code: ResultCode
    var message: String
    var data: T
    
    static func success(data: T) -> Self {
        Self(code: .成功, message: "success", data: data)
    }

    static func success(message: String, data: T) -> Self {
        Self(code: .成功, message: message, data: data)
    }

    static func fail(code: ResultCode, data: T) -> Self {
        Self(code: code, message: code.description, data: data)
    }
}

enum ResultCode: Int, Codable {
    case 出错 = -1
    case 成功 = 0
    
    // MARK: General Errors
    case 参数匹配失败 = 1001
    
    // MARK: Login
    case 密码错误 = 2001
    
    var description: String {
        get {
            switch self {
            case .成功:
                return "成功"
            case .出错:
                return "出错"
            case .参数匹配失败:
                return "参数匹配失败"
            case .密码错误:
                return "密码错误"
            }
        }
    }
}
