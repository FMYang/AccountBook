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
    
    static func currentYear() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        let year = components.year
        if let y = year {
            return "\(y)"
        }
        return ""
    }
    
    static func currentMonth() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: Date())
        let month = components.month
        if let m = month {
            return "\(m)"
        }
        return ""
    }
}
