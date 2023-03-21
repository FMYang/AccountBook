//
//  UIViewController+Response.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/21.
//

import UIKit

func topViewController() -> UIViewController? {
    var vc = UIApplication.shared.zy_keyWindow?.rootViewController
    while vc?.presentedViewController != nil {
        vc = vc?.presentedViewController
        if vc?.isKind(of: UINavigationController.self) == true {
            vc = (vc as? UINavigationController)?.visibleViewController
        } else if vc?.isKind(of: UITabBarController.self) == true {
            vc = (vc as? UITabBarController)?.selectedViewController
        }
    }
    return vc ?? nil
}
