//
//  FMActionSheetAnimator.swift
//  ViewControllerTransitionAnimation
//
//  Created by yfm on 2019/5/26.
//  Copyright © 2019年 yfm. All rights reserved.
//

import UIKit

class FMActionSheetAnimator: FMBaseAnimator {
    /// 显示视图
    override func presentAlertViewController(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! FMAnimationViewController
        transitionContext.containerView.addSubview(toVC.view)
        
        toVC.containerView.transform = CGAffineTransform(translationX: 0, y: toVC.view.frame.size.height)
        
        UIView.animate(withDuration: 0.25, animations: {
            toVC.containerView.transform = CGAffineTransform.identity
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
    /// 隐藏视图
    override func dismissAlertViewController(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! FMAnimationViewController
        
        fromVC.containerView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.25, animations: {
            fromVC.containerView.transform = CGAffineTransform(translationX: 0, y: fromVC.containerView.frame.size.height)
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
}
