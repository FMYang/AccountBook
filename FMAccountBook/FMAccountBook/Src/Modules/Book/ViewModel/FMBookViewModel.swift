//
//  FMBookViewModel.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import Foundation

class FMBookViewModel {
    
    var refreshBlock: (()->())?
    
    var datasource = [FMAccount]()
    
    func numberOfSections() -> Int {
        return datasource.count
    }
    
    func data(indexPath: IndexPath) -> FMAccount {
        return datasource[indexPath.section]
    }
    
    func addBook(name: String) {
        let book = FMAccount()
        book.name = name
        book.cover = "\(arc4random() % 29 + 1).jpeg"
        book.date = String.currentDate(dateFormat: .date_en)
        asyncCall { DBManager.insert(object: book) }
    }
    
    func query() {
        asyncCall {
            DBManager.query(object: FMAccount.self) { [weak self] accounts in
                DispatchQueue.main.async {
                    if let accounts = accounts as? [FMAccount] {
                        self?.datasource = accounts
                        self?.refreshBlock?()
                    }
                }
            }
        }
    }
    
    func delete(indexPath: IndexPath) {
        let model = datasource[indexPath.section]
        asyncCall { [weak self] in
            DBManager.delete(object: FMAccount.self, condition: "account_id = \(model.account_id)")
            DispatchQueue.main.async {
                self?.query()
            }
        }
    }
}
