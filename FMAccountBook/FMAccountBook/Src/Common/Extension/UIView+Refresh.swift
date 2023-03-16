//
//  UIView+Refresh.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/16.
//

import Foundation
import KafkaRefresh

extension UIView {
    static func configRefreshStyle() {
        KafkaRefreshDefaults.standard()?.headDefaultStyle = .native
        KafkaRefreshDefaults.standard()?.footDefaultStyle = .native
        KafkaRefreshDefaults.standard()?.themeColor = selectedColor
    }
}
