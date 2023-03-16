//
//  FMTextField.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/16.
//

import UIKit

class FMTextField: UITextField {
    
    // 禁用选择、粘贴等
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    // 禁用放大镜
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureDelegate = gestureRecognizer.delegate {
            if(gestureDelegate.description.localizedCaseInsensitiveContains("UITextLoupeInteraction")) {
                return false;
            }
        }
        return true;
    }
}
