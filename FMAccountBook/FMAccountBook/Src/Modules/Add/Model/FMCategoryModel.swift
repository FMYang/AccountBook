//
//  FMCategoryModel.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/9.
//

import Foundation

class FMCategoryModel {
    var selected: Bool = false
    var catetory: TradeCategory = .dining
    
    static func datasouce(data: [TradeCategory]) -> [FMCategoryModel] {
        var result = [FMCategoryModel]()
        for category in data {
            let model = FMCategoryModel()
            model.selected = false
            model.catetory = category
            result.append(model)
        }
        result[0].selected = true
        return result
    }
}
