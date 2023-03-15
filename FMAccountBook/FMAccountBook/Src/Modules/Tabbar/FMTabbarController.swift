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

        let vc: UIViewController
        switch self {
        case .detail:
            vc = FMDetalVC()
        case .accountBook:
            vc = FMBookVC()
        }
        vc.tabBarItem = item
        let nav = FMNavigationController(rootViewController: vc)
        
        // 设置导航栏背景色
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = bgColor
        // 隐藏底部线
        barAppearance.shadowImage = UIImage()
        barAppearance.shadowColor = nil
        nav.navigationBar.standardAppearance = barAppearance
        nav.navigationBar.scrollEdgeAppearance = barAppearance
        
        // 设置导航栏不透明
        nav.navigationBar.isTranslucent = false
        return nav
    }
}

class FMTabbarController: UITabBarController {

    private let items: [ItemType] = [.detail, .accountBook]

    override func viewDidLoad() {
        super.viewDidLoad()
        configAppearance()
        viewControllers = items.map { $0.getController() }
    }
    
    func configAppearance() {
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        
        // tabbaritem标题选中色
        let barApp = UITabBarAppearance()
        let barItemNormal = barApp.stackedLayoutAppearance.normal
        let barItemSelected = barApp.stackedLayoutAppearance.selected
        barItemNormal.titleTextAttributes = [.foregroundColor : UIColor.gray]
        barItemSelected.titleTextAttributes = [.foregroundColor : UIColor.black]
        tabBar.standardAppearance = barApp
    }
}
