//
//  FMDetailViewModel.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/15.
//

import Foundation
import UIKit

class FMDetailViewModel {
    
    var listDataChangedBlock: (()->())?
    
    var listData: [FMDetailListModel] = [] {
        didSet {
            listDataChangedBlock?()
        }
    }
    
    func fetchData(month: String) {
        asyncCall { [weak self] in
            let model = FMDetailListModel()
            model.month = month
            let iconName = "\(arc4random() % 29 + 1).jpeg"
            model.imageName = iconName
            
            // 总支出
            DBManager.shared.dbQueue?.inDatabase({ db in
                let sql = "select sum(tradeAmount) as total_amount from \(FMRecord.tableName) where strftime('%m', date) = '\(month)' and tradeType = \(TradeType.expense.rawValue)"
                do {
                    let ret = try db.executeQuery(sql, values: nil)
                    while ret.next() {
                        let amount = ret.double(forColumn: "total_amount")
                        print("amount = \(amount)")
                        model.totalExpense = amount
                    }
                } catch {
                    print(error)
                }
            })

            // 总收入
            DBManager.shared.dbQueue?.inDatabase({ db in
                let sql = "select sum(tradeAmount) as total_amount from \(FMRecord.tableName) where strftime('%m', date) = '\(month)' and tradeType = \(TradeType.income.rawValue)"
                do {
                    let ret = try db.executeQuery(sql, values: nil)
                    while ret.next() {
                        let amount = ret.double(forColumn: "total_amount")
                        print("amount = \(amount)")
                        model.totalIncome = amount
                    }
                } catch {
                    print(error)
                }
            })

            // 查询3月数据集合
            DBManager.query(object: FMRecord.self, condition: "strftime('%m', date) = '\(month)'", orderBy: "date", isDesc: true, limit: 10, offset: 0) { records in
                if let data = records as? [FMRecord] {
                    model.list = data
                }
            }
            
            var result = [FMDetailListModel]()
            result.append(model)
            
            DispatchQueue.main.async {
                self?.listData = result
            }
        }
    }
    
    func numberOfSections() -> Int {
        return listData.count
    }
    
    func numberOfRows(section: Int) -> Int {
        return listData[section].list.count
    }
    
    func listModel(indexPath: IndexPath) -> FMRecord {
        return listData[indexPath.section].list[indexPath.row]
    }
    
    func headerModel(section: Int) -> FMDetailListModel {
        return listData[section]
    }
    
    func delete(indexPath: IndexPath) {
        let record = listData[indexPath.section].list[indexPath.row]
//        listData[indexPath.section].list.remove(at: indexPath.row)
        asyncCall {
            DBManager.delete(object: FMRecord.self, condition: "id = \(record.id)")
        }
//        listDataChangedBlock?()
    }
}
