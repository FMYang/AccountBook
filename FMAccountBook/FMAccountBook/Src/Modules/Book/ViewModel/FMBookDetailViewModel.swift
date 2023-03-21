//
//  FMBookDetailViewModel.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/21.
//

import Foundation

class FMBookDetailViewModel {
    
    var loadDataBlock: (() -> Void)?
    var datasource: [FMRecord] = []
    
    func numberOfRows() -> Int {
        return datasource.count
    }
    
    func model(indexPath: IndexPath) -> FMRecord {
        return datasource[indexPath.row]
    }
    
    func query(accountId: Int) {
        asyncCall {
            DBManager.shared.dbQueue?.inDatabase({ db in
                let sql = "select * from \(FMRecord.tableName) r inner join \(FMAccount_Record.tableName) ar on r.record_id = ar.record_id where ar.account_id = \(accountId) order by date desc"
                do {
                    let result = try db.executeQuery(sql, values: nil)
                    var data = [FMRecord]()
                    while result.next() {
                        if let model = FMRecord.toModel(resultSet: result) as? FMRecord {
                            data.append(model)
                            
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.datasource = data
                        self?.loadDataBlock?()
                    }
                } catch {
                    print(error)
                }
            })
        }
    }
}
