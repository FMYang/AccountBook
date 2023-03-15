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
        view.backgroundColor = .white.withAlphaComponent(0.6)
        return view
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "3月"
        label.font = .systemFont(ofSize: 50, weight: .light)
        return label
    }()
    
    lazy var incomeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "收入: "
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var expenseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "支出: "
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var expenseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var surplusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "结余: "
        return label
    }()
    
    lazy var surplusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: FMDetailListModel) {
        //        let url = URL(string: "https://picsum.photos/600/400")!
        //        bgImageView.kf.setImage(with: .network(url))
        monthLabel.text = model.month + "月"
        bgImageView.image = UIImage(named: model.imageName)
        expenseLabel.text = String(format: "¥ %.2f", model.totalExpense)
        incomeLabel.text = String(format: "¥ %.2f", model.totalIncome)
        surplusLabel.text = String(format: "¥ %.2f", model.totalIncome - model.totalExpense)
    }
    
    func makeUI() {
        addSubview(bgImageView)
        addSubview(coverView)
        addSubview(monthLabel)
        addSubview(expenseTitleLabel)
        addSubview(expenseLabel)
        addSubview(incomeTitleLabel)
        addSubview(incomeLabel)
        addSubview(expenseLabel)
        addSubview(surplusTitleLabel)
        addSubview(surplusLabel)
        
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
        
        expenseTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(monthLabel)
            make.top.equalTo(monthLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        expenseLabel.snp.makeConstraints { make in
            make.left.equalTo(expenseTitleLabel.snp.right).offset(5)
            make.centerY.equalTo(expenseTitleLabel)
        }
        
        incomeTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(incomeLabel)
            make.right.equalTo(incomeLabel.snp.left).offset(-5)
        }
        
        incomeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(expenseLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        surplusTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(expenseTitleLabel)
            make.top.equalTo(expenseTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        surplusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(surplusTitleLabel)
            make.left.equalTo(surplusTitleLabel.snp.right).offset(5)
        }
    }
    
}
