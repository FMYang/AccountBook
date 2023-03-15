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
}

