//
//  FMBaseAlertView.swift
//  ViewControllerTransitionAnimation
//
//  Created by yfm on 2019/5/24.
//  Copyright © 2019年 yfm. All rights reserved.
//

import UIKit

class FMBaseAnimationView: UIView {
    // 默认宽度约束
    public var widthConstraint: Float = 280
    
    private var transitionViewController: FMAnimationViewController? {
        get {
            var responder = self.next
            while responder != nil {
                if let responder = responder, responder.isKind(of: FMAnimationViewController.self) {
                    return responder as? FMAnimationViewController
                } else {
                    responder = responder?.next
                }
            }
            
            return nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FMBaseAnimationView {
    public func show(in viewController: UIViewController, style: AnimationType) {
        let transitionVC = FMAnimationViewController(style: style, containerView: self)
        transitionVC.show(in: viewController)
    }
    
    public func dismiss() {
        transitionViewController?.dismiss()
    }
}
