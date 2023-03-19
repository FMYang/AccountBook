//
//  FMAccount_Record.swift
//  FMAccountBook
//
//  Created by wei peng on 2023/3/19.
//

import Foundation
import FMDB

class FMAccount_Record {
    // 记录id
    var record_id: Int = 0
    // 账本id
    var account_id: Int = 0
}

extension FMAccount_Record: DBProtocol {
    static var tableName: String {
        return "Account_Record"
    }
    
    static var columns: [[String : String]] {
        return [["record_id": "integer"], ["account_id": "integer"]]
    }
    
    static var createSql: String {
        return "create table if not exists \(tableName) (record_id integer, account_id integer, foreign key (account_id) references account(account_id), foreign key (record_id) references record(record_id), primary key (account_id, record_id))"
    }
    
    var insertSql: String {
        return "insert or replace into \(FMAccount_Record.tableName) (record_id, account_id) values (\(record_id), \(account_id))"
    }
    
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        let model = FMAccount_Record()
        model.account_id = Int(resultSet.int(forColumn: "account_id"))
        model.record_id = Int(resultSet.int(forColumn: "record_id"))
        return model
    }
}
