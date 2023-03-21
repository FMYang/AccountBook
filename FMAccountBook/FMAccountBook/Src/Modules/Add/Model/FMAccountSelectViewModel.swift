//
//  FMAccountSelectViewModel.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import Foundation

class FMAccountSelectModel {
    var selected: Bool = false
    var account: FMAccount
    
    init(account: FMAccount) {
        self.account = account
    }
}

class FMAccountSelectViewModel {
    
    var loadDataBlock: (()->())?
        
    var datasource = [FMAccountSelectModel]()
    
    func selectedIds() -> [Int] {
        let ids = datasource.filter { $0.selected }.map { $0.account.account_id }
        return ids
    }
    
    func numberOfRows() -> Int {
        return datasource.count
    }
    
    func select(indexPath: IndexPath) {
        datasource.forEach { $0.selected = false }
        datasource[indexPath.row].selected = true
    }
    
    func query() {
        asyncCall {
            DBManager.query(object: FMAccount.self) { [weak self] accounts in
                DispatchQueue.main.async {
                    if let accounts = accounts as? [FMAccount] {
                        self?.datasource = accounts.map { FMAccountSelectModel(account: $0) }
                        self?.loadDataBlock?()
                    }
                }
            }
        }
    }
    
    static func maxRecordId() -> Int {
        var id = 0
        DBManager.shared.dbQueue?.inDatabase({ db in
            do {
                let result = try db.executeQuery("select MAX(record_id) from \(FMRecord.tableName)", values: [])
                while result.next() {
                    id = (result.resultDictionary?["MAX(record_id)"] as? Int) ?? 0
                }
            } catch {
                print(error)
            }
        })
        return id
    }
}
