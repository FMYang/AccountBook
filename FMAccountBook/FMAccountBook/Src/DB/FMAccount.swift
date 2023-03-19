//
//  FMAccountBook.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/9.
//

import Foundation
import FMDB

class FMAccount {
    // 账本id
    var account_id: Int = 0
    // 账本名
    var name: String = ""
    // 封面图片名
    var cover: String = ""
}

extension FMAccount: DBProtocol {
    static var tableName: String {
        return "Account"
    }
    
    static var columns: [[String : String]] {
        return [["account_id": "integer"], ["name": "text"], ["cover": "text"]]
    }
    
    static var createSql: String {
        return "create table if not exists \(tableName) (account_id integer primary key, name text, cover text)"
    }
    
    var insertSql: String {
        return "insert or replace into \(FMAccount.tableName) (name, cover) values ('\(name)', '\(cover)')"
    }
    
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        let book = FMAccount()
        book.account_id = Int(resultSet.int(forColumn: "account_id"))
        book.name = resultSet.string(forColumn: "name") ?? ""
        book.cover = resultSet.string(forColumn: "cover") ?? ""
        return book
    }
}
