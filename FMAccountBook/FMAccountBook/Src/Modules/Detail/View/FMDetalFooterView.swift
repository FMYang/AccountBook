//
//  FMDetalFooterView.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/14.
//

import UIKit

class FMDetalFooterView: UITableViewHeaderFooterView {

    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = bgColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        view.layer.masksToBounds = true
        view.layer.isOpaque = true
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(borderView)
        addSubview(coverView)
        borderView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        coverView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(0.5)
            make.right.equalToSuperview().offset(-0.5)
            make.height.equalTo(1)
        }
    }
}
