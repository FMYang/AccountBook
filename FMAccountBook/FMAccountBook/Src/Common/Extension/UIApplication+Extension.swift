//
//  UIApplication+Extension.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/15.
//

import UIKit

extension UIApplication {
    public var zy_keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return windows.filter { $0.isKeyWindow }.first
        } else {
            return keyWindow
        }
    }
}
