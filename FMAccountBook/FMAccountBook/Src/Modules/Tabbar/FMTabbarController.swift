//
//  TabbarController.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit
import SnapKit

enum ItemType {
    case detail
    case accountBook

    var itemTitle: String {
        switch self {
        case .detail:
            return "明细"
        case .accountBook:
            return "账本"
        }
    }
    
    var normalImage: UIImage? {
        switch self {
        case .detail:
            return UIImage(named: "detail_normal")
        case .accountBook:
            return UIImage(named: "ledger_normal")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .detail:
            return UIImage(named: "detail_selected")
        case .accountBook:
            return UIImage(named: "ledger_selected")
        }
    }

    func getController() -> UIViewController {
        let item = UITabBarItem(title: self.itemTitle, image: self.normalImage?.withRenderingMode(.alwaysOriginal), selectedImage: self.selectedImage?.withRenderingMode(.alwaysOriginal))
        item.setTitleTextAttributes([.foregroundColor : UIColor.gray], for: .normal)
        item.setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)

        let vc: UIViewController
        switch self {
        case .detail:
            vc = FMDetalVC()
        case .accountBook:
            vc = FMBookVC()
        }
        vc.tabBarItem = item
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        return nav
    }
}

class FMTabbarController: UITabBarController {

    private let items: [ItemType] = [.detail, .accountBook]

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        viewControllers = items.map { $0.getController() }
    }
}
