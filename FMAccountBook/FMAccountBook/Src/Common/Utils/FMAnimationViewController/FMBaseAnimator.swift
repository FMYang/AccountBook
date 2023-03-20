//
//  FMBaseAnimator.swift
//  ViewControllerTransitionAnimation
//
//  Created by yfm on 2019/5/26.
//  Copyright © 2019年 yfm. All rights reserved.
//

import UIKit

open class FMBaseAnimator: NSObject {
    var isPresenting: Bool = true
    
    convenience init(isPresenting: Bool, style: AnimationType) {
        self.init()
        self.isPresenting = isPresenting
    }
    
    func presentAlertViewController(using transitionContext: UIViewControllerContextTransitioning) {
        // 子类实现自定义显示动画
    }
    
    func dismissAlertViewController(using transitionContext: UIViewControllerContextTransitioning) {
        // 子类实现自定义隐藏动画
    }
}

extension FMBaseAnimator: UIViewControllerAnimatedTransitioning {
    /// 动画执行的时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    /// 转场动画代理方法，在这里做转场动画
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAlertViewController(using: transitionContext)
        } else {
            self.dismissAlertViewController(using: transitionContext)
        }
    }
}
