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
    var listData: [FMDetailListModel] = []
    
    // 当前月份总支出/收入
    func totalSum(tradeType: TradeType, condition: String) -> Double {
        var totalAmount = 0.0
        DBManager.shared.dbQueue?.inDatabase({ db in
            let sql = "select sum(tradeAmount) as total_amount from \(FMRecord.tableName) where strftime('%Y-%m', date) = '\(condition)' and tradeType = \(tradeType.rawValue)"
            do {
                let ret = try db.executeQuery(sql, values: nil)
                while ret.next() {
                    let amount = ret.double(forColumn: "total_amount")
                    totalAmount = amount
                }
            } catch {
                print(error)
            }
        })
        return totalAmount
    }
    
    // 当前年月记录
    func fetchData(year: Int, month: Int) {
        asyncCall { [weak self] in
            let model = FMDetailListModel()
            model.year = "\(year)"
            model.month = "\(month)"
            model.imageName = "\(arc4random() % 29 + 1).jpeg"
            
            let condition = String(format: "%04d-%02d", year, month)
            
            model.totalExpense = self?.totalSum(tradeType: .expense, condition: condition) ?? 0.0
            model.totalIncome = self?.totalSum(tradeType: .income, condition: condition) ?? 0.0

            // 当前月份记录
            DBManager.query(object: FMRecord.self, condition: "strftime('%Y-%m', date) = '\(condition)'", orderBy: "date", isDesc: true) { records in
                if let data = records as? [FMRecord] {
                    model.list = data
                }
            }
            
            var result = [FMDetailListModel]()
            result.append(model)
            
            DispatchQueue.main.async {
                self?.listData = model.list.count > 0 ? result : []
                self?.listDataChangedBlock?()
            }
        }
    }
    
    // 加载更多
    func fetchMoreData(completion: @escaping (()->())) {
        asyncCall { [weak self] in
            let date = self?.listData.last?.list.last?.date ?? ""

            DBManager.query(object: FMRecord.self, condition: "date < '\(date)'", orderBy: "date", isDesc: true) { [weak self] records in
                if let data = records as? [FMRecord] {
                    for record in data {
                        let year = "\(String.year(date: record.date))"
                        let month = "\(String.month(date: record.date))"
                        let existModel = self?.listData.first { $0.year == year && $0.month == month }
                        if existModel != nil {
                            existModel?.list.append(record)
                        } else {
                            let model = FMDetailListModel()
                            model.imageName = "\(arc4random() % 29 + 1).jpeg"
                            model.year = year
                            model.month = month
                            model.list.append(record)
                            self?.listData.append(model)
                        }
                    }
                }
            }
            
            if let list = self?.listData {
                for data in list {
                    if data.list.count > 0 {
                        let record = data.list.first!
                        if data.totalIncome < 0.1 {
                            let y = String.year(date: record.date)
                            let m = String.month(date: record.date)
                            let condition = String(format: "%04d-%02d", y, m)
                            data.totalIncome = self?.totalSum(tradeType: .income, condition: condition) ?? 0.0
                        }
                        if data.totalExpense < 0.1 {
                            let y = String.year(date: record.date)
                            let m = String.month(date: record.date)
                            let condition = String(format: "%04d-%02d", y, m)
                            data.totalExpense = self?.totalSum(tradeType: .expense, condition: condition) ?? 0.0
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.listDataChangedBlock?()
                completion()
            }
        }
    }
    
    // 筛选数据
    func fetchData(minAmount: Double, maxAmount: Double, categorys: [TradeCategory]) {
        asyncCall { [weak self] in
            var condition = ""
            if minAmount > 0 && maxAmount > 0 {
                condition += "tradeAmount >= \(minAmount) and tradeAmount <= \(maxAmount)"
            } else if minAmount > 0 {
                condition += "tradeAmount >= \(minAmount)"
            } else if maxAmount > 0 {
                condition += "tradeAmount <= \(maxAmount)"
            }
            for i in 0..<categorys.count {
                let category = categorys[i]
                let value = category.rawValue
                if minAmount > 0 || maxAmount > 0 {
                    condition += " or category = \(value)"
                } else {
                    if i == categorys.count - 1 {
                        condition += "category = \(value)"
                    } else {
                        condition += "category = \(value) or "
                    }
                }
            }
            
            var result = [FMDetailListModel]()
            DBManager.query(object: FMRecord.self, condition: condition, orderBy: "date", isDesc: true) { records in
                if let data = records as? [FMRecord] {
                    for record in data {
                        let year = "\(String.year(date: record.date))"
                        let month = "\(String.month(date: record.date))"
                        let existModel = result.first { $0.year == year && $0.month == month }
                        if existModel != nil {
                            existModel?.list.append(record)
                        } else {
                            let model = FMDetailListModel()
                            model.imageName = "\(arc4random() % 29 + 1).jpeg"
                            model.year = year
                            model.month = month
                            model.list.append(record)
                            result.append(model)
                        }
                    }
                    print(result)
                }
            }
            
            for data in result {
                if data.list.count > 0 {
                    let record = data.list.first!
                    if data.totalIncome < 0.1 {
                        let y = String.year(date: record.date)
                        let m = String.month(date: record.date)
                        let condition = String(format: "%04d-%02d", y, m)
                        data.totalIncome = self?.totalSum(tradeType: .income, condition: condition) ?? 0.0
                    }
                    if data.totalExpense < 0.1 {
                        let y = String.year(date: record.date)
                        let m = String.month(date: record.date)
                        let condition = String(format: "%04d-%02d", y, m)
                        data.totalExpense = self?.totalSum(tradeType: .expense, condition: condition) ?? 0.0
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.listData = result
                self?.listDataChangedBlock?()
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
        asyncCall { DBManager.delete(object: FMRecord.self, condition: "id = \(record.id)") }
    }
}
