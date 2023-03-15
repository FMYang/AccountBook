//
//  FMNavigationController.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/15.
//

import UIKit

class FMNavigationController: UINavigationController, UIGestureRecognizerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        viewController.hidesBottomBarWhenPushed = viewControllers.count > 0
        
        if viewControllers.count > 0 {
            let backButton = UIButton()
            backButton.setImage(UIImage(named: "back"), for: .normal)
            backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            
            let backItem = UIBarButtonItem(customView: backButton)
            viewController.navigationItem.leftBarButtonItem = backItem
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backAction() {
        popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            return true
        }
        return false
    }
}
