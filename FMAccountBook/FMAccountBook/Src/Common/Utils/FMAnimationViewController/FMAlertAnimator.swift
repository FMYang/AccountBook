//
//  Animator.swift
//  ViewControllerTransitionAnimation
//
//  Created by yfm on 2019/5/23.
//  Copyright © 2019年 yfm. All rights reserved.
//

import UIKit

class FMAlertAnimator: FMBaseAnimator {
    /// 显示视图
    override func presentAlertViewController(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! FMAnimationViewController
        transitionContext.containerView.addSubview(toVC.view)
        
        toVC.backgroundView.alpha = 0.0
        toVC.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.25, animations: {
            toVC.backgroundView.alpha = 1.0
            toVC.containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                toVC.containerView.transform = CGAffineTransform.identity
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
    
    /// 隐藏视图
    override func dismissAlertViewController(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! FMAnimationViewController
        fromVC.containerView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.25, animations: {
            fromVC.backgroundView.alpha = 0.0
            fromVC.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
