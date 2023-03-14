//
//  String+Extension.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/14.
//

import Foundation

extension String {
    static func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        let date = Date()
        return formatter.string(from: date)
    }
}

