//
//  SecondViewController.swift
//  ViewControllerTransitionAnimation
//
//  Created by yfm on 2019/5/23.
//  Copyright © 2019年 yfm. All rights reserved.
//

import UIKit
import SnapKit

/// 转场动画类型
///
/// - scale: 缩放
/// - dropDown: 底部弹出
public enum AnimationType {
    case alert
    case actionSheet
}

class FMAnimationViewController: UIViewController {
    
    // MARK: - property
    var containerView: FMBaseAnimationView!
    var widthConstraint: Float = 280
    var backgroundEnableDismiss: Bool = true
    var style: AnimationType = .alert
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    // MARK: - life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setupController()
    }
    
    convenience init(style: AnimationType,
                     containerView: FMBaseAnimationView?) {
        self.init()
        
        self.style = style

        if let containerView = containerView {
            self.widthConstraint = containerView.widthConstraint
            self.containerView = containerView
        } else {
            self.containerView = FMBaseAnimationView()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景视图添加点击事件
        let tapGestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancel(recognizer:)))
        self.backgroundView.addGestureRecognizer(tapGestrueRecognizer)
        
        setupSubViews()
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - config method
    private func setupController() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    private func setupSubViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            switch style {
            case .alert:
                make.center.equalToSuperview()
                make.width.equalTo(widthConstraint)
            case .actionSheet:
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - action
    @objc func cancel(recognizer: UIGestureRecognizer) {
        let point = recognizer.location(in: backgroundView)
        let rect = containerView.frame
        // 判断是否点击的内容视图
        if rect.contains(point) {
            return
        }
        if backgroundEnableDismiss {
            self.dismiss()
        }
    }
}

// MARK: - extension
extension FMAnimationViewController {
    public func show(in viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }
    
    public func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FMAnimationViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch style {
        case .alert:
            return FMAlertAnimator(isPresenting: true, style: self.style)
        case .actionSheet:
            return FMActionSheetAnimator(isPresenting: true, style: self.style)
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch style {
        case .alert:
            return FMAlertAnimator(isPresenting: false, style: self.style)
        case .actionSheet:
            return FMActionSheetAnimator(isPresenting: false, style: self.style)
        }
    }
}
