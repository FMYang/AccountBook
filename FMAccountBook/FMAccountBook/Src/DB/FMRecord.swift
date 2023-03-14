//
//  FMRecord.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit
import FMDB

enum TradeType: Int {
    // 支出
    case expense
    // 收入
    case income
}

enum TradeCategory: Int {
    // 餐饮
    case dining
    // 出行
    case travel
    // 红包
    case redEnvelope
    // 房租
    case rent
    // 休闲娱乐
    case entertainment
    // 充值缴费
    case payment
    // 购物
    case shopping
    // 转账给他人
    case transferToOther
    // 服饰
    case clothing
    // 生活用品
    case daily
    
    // 薪酬
    case salary
    // 基金
    case fund
    // 退款
    case refund
    // 他人转入
    case transferFromOthers
    // 债券
    case bond
    // 现金
    case cash
    // 报销
    case reimbursement
    
    var title: String {
        switch self {
        case .dining:
            return "餐饮"
        case .travel:
            return "出行"
        case .redEnvelope:
            return "红包"
        case .rent:
            return "房租"
        case .entertainment:
            return "休闲娱乐"
        case .payment:
            return "充值缴费"
        case .shopping:
            return "购物"
        case .transferToOther:
            return "转账给他人"
        case .clothing:
            return "服饰"
        case .daily:
            return "生活用品"
        case .salary:
            return "薪酬"
        case .fund:
            return "基金"
        case .refund:
            return "退款"
        case .transferFromOthers:
            return "他人转入"
        case .bond:
            return "债券"
        case .cash:
            return "现金"
        case .reimbursement:
            return "报销"
        }
    }
    
    var iconNormal: UIImage? {
        switch self {
        case .dining:
            return UIImage(named: "餐饮_normal")
        case .travel:
            return UIImage(named: "出行_normal")
        case .redEnvelope:
            return UIImage(named: "红包_normal")
        case .rent:
            return UIImage(named: "房租_normal")
        case .entertainment:
            return UIImage(named: "休闲娱乐_normal")
        case .payment:
            return UIImage(named: "充值缴费_normal")
        case .shopping:
            return UIImage(named: "购物_normal")
        case .transferToOther:
            return UIImage(named: "转账给他人_normal")
        case .clothing:
            return UIImage(named: "服饰_normal")
        case .daily:
            return UIImage(named: "生活用品_normal")
        case .salary:
            return UIImage(named: "薪酬_normal")
        case .fund:
            return UIImage(named: "基金_normal")
        case .refund:
            return UIImage(named: "退款_normal")
        case .transferFromOthers:
            return UIImage(named: "他人转入_normal")
        case .bond:
            return UIImage(named: "债券_normal")
        case .cash:
            return UIImage(named: "现金_normal")
        case .reimbursement:
            return UIImage(named: "报销_normal")
        }
    }
    
    var iconSelected: UIImage? {
        switch self {
        case .dining:
            return UIImage(named: "餐饮_selected")
        case .travel:
            return UIImage(named: "出行_selected")
        case .redEnvelope:
            return UIImage(named: "红包_selected")
        case .rent:
            return UIImage(named: "房租_selected")
        case .entertainment:
            return UIImage(named: "休闲娱乐_selected")
        case .payment:
            return UIImage(named: "充值缴费_selected")
        case .shopping:
            return UIImage(named: "购物_selected")
        case .transferToOther:
            return UIImage(named: "转账给他人_selected")
        case .clothing:
            return UIImage(named: "服饰_selected")
        case .daily:
            return UIImage(named: "生活用品_selected")
        case .salary:
            return UIImage(named: "薪酬_selected")
        case .fund:
            return UIImage(named: "基金_selected")
        case .refund:
            return UIImage(named: "退款_selected")
        case .transferFromOthers:
            return UIImage(named: "他人转入_selected")
        case .bond:
            return UIImage(named: "债券_selected")
        case .cash:
            return UIImage(named: "现金_selected")
        case .reimbursement:
            return UIImage(named: "报销_selected")
        }
    }
}

class FMRecord {
    // 交易id
    var id: Int = 0
    // 交易金额
    var tradeAmount: Double = 0.0
    // 交易类型
    var tradeType: TradeType = .expense
    // 交易分类
    var category: TradeCategory = .dining
    // 交易日期
    var date: String = ""
    // 所属账本
    var accountBookIds: String?
}

extension FMRecord: DBProtocol {
    
    static var tableName: String {
        return "Record"
    }
    
    static var columns: [[String : String]] {
        return [["id": "integer"],
                ["tradeAmount": "real"],
                ["tradeType": "integer"],
                ["category": "integer"],
                ["date": "text"],
                ["accountBookIds": "text"]]
    }
    
    static var createSql: String {
        return "create table if not exists \(tableName) (id integer primary key, tradeAmount real, tradeType integer, category integer, date text, accountBookIds text)"
    }
    
    var insertSql: String {
        return "insert or replace into \(FMRecord.tableName) (tradeAmount, tradeType, category, date, accountBookIds) values (\(tradeAmount), \(tradeType.rawValue), \(category.rawValue), '\(date)', '\(accountBookIds ?? "")')"
    }
    
    static func toModel(resultSet: FMResultSet) -> DBProtocol {
        let record = FMRecord()
        record.id = Int(resultSet.int(forColumn: "id"))
        record.tradeAmount = resultSet.double(forColumn: "tradeAmount")
        record.tradeType = TradeType(rawValue: Int(resultSet.int(forColumn: "tradeType"))) ?? .expense
        record.category = TradeCategory(rawValue: Int(resultSet.int(forColumn: "category"))) ?? .dining
        record.date = resultSet.string(forColumn: "date") ?? ""
        record.accountBookIds = resultSet.string(forColumn: "accountBookIds")
        return record
    }
}
