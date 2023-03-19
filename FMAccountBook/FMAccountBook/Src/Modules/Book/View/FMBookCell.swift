//
//  FMBookCell.swift
//  FMAccountBook
//
//  Created by wei peng on 2023/3/19.
//

import UIKit

class FMBookCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "默认账本"
        return label
    }()
    
    lazy var monthExpenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.text = "月支出  ¥ 1000.0"
        return label
    }()
    
    lazy var monthIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.text = "月收入  ¥ 1000.0"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        iconImageView.image = UIImage(named: "\(arc4random() % 29 + 1).jpeg")
    }
    
    func makeUI() {
        contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(monthExpenseLabel)
        bgView.addSubview(monthIncomeLabel)

        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(0)
        }
                
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView).offset(10)
            make.left.equalTo(iconImageView.snp.right).offset(20)
            make.height.equalTo(30)
        }
        
        monthExpenseLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        monthIncomeLabel.snp.makeConstraints { make in
            make.top.equalTo(monthExpenseLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
            make.height.equalTo(20)
        }
    }
}
