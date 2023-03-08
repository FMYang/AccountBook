//
//  FMDetalVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit

class FMDetalVC: UIViewController {
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "icon_add"), for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 8
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "收支"
        makeUI()
    }
    
    @objc func addAction() {
        let vc = FMAddVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeUI() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}
