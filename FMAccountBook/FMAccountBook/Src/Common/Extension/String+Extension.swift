//
//  String+Extension.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/14.
//

import Foundation

enum FMDateFormat: String {
    case date_en = "yyyy-MM-dd HH:mm:ss"
    case date_cn = "yyyy年MM月dd日"
    case time = "HH:mm:ss"
    case month = "MM"
}

extension String {

    static func currentDate(dateFormat: FMDateFormat) -> String {
        return currentDate(format: dateFormat.rawValue)
    }
    
    static func currentDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        let date = Date()
        return formatter.string(from: date)
    }
    
    static func year(date: String) -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tmpDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy"
        if let tmp = tmpDate {
            if let year = Int(formatter.string(from: tmp)) {
                return year
            }
        }
        return 1970
    }
    
    static func month(date: String) -> Int {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let tmpDate = formatter.date(from: date)
        formatter.dateFormat = "MM"
        if let tmp = tmpDate {
            if let month = Int(formatter.string(from: tmp)) {
                return month
            }
        }
        return 0
    }
}

