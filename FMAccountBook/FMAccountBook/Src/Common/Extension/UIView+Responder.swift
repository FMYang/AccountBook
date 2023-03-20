//
//  UIView+Response.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import UIKit

extension UIView {
    func topViewController() -> UIViewController? {
        var responder: UIResponder? = self.subviews.first
        while responder != nil {
            responder = responder!.next
            if responder?.isKind(of: UIViewController.self) != nil {
                return responder as? UIViewController
            }
        }
        return nil
    }
}
