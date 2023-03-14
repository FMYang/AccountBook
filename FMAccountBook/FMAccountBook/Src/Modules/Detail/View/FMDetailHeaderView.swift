//
//  FMDetailHeaderView.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/14.
//

import UIKit
import Kingfisher

class FMDetailHeaderView: UITableViewHeaderFooterView {
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "3月"
        label.font = .systemFont(ofSize: 50, weight: .light)
        return label
    }()
    
    lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.text = "收入：¥ 10"
        return label
    }()
    
    lazy var expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "支出：¥ 10"
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        let url = URL(string: "https://picsum.photos/600/400")!
        bgImageView.kf.setImage(with: .network(url))
    }
    
    func makeUI() {
        addSubview(bgImageView)
        addSubview(coverView)
        addSubview(monthLabel)
        addSubview(expenseLabel)
        addSubview(incomeLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }
        
        expenseLabel.snp.makeConstraints { make in
            make.left.equalTo(monthLabel)
            make.top.equalTo(monthLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        incomeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(expenseLabel)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
}
