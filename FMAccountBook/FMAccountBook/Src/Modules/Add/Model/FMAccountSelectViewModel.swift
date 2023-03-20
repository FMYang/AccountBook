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
    var datasource = [FMAccountSelectModel]()
    
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
                    }
                }
            }
        }
    }
}
