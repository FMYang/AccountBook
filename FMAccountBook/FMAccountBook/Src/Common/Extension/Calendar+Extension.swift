//
//  Calendar+Extension.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/14.
//

import Foundation

extension Calendar {
    static func currentYearMonth() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        let year = components.year
        let month = components.month
        if let y = year, let m = month {
            return "\(y)-\(m)"
        }
        return ""
    }
    
    static func currentYear() -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        let year = components.year
        return year
    }
    
    static func currentMonth() -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: Date())
        let month = components.month
        return month
    }
}
