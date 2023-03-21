//
//  FMDetailCell.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/9.
//

import UIKit

class FMDetailCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var leftLine: UIImageView = {
        let view = UIImageView()
        view.image = UIColor.createImage(color: UIColor.gray.withAlphaComponent(0.2))
        return view
    }()
    
    lazy var rigthLine: UIImageView = {
        let view = UIImageView()
        view.image = UIColor.createImage(color: UIColor.gray.withAlphaComponent(0.2))
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
        
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: FMRecord) {
        iconImageView.image = model.category.iconNormal
        titleLabel.text = model.category.title
        amountLabel.text = (model.tradeType == .expense ? "-" : "+") + String(format: " ¥ %.2f", model.tradeAmount)
        dateLabel.text = model.date
    }
    
    func makeUI() {
        contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(amountLabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(leftLine)
        bgView.addSubview(rigthLine)
        bgView.addSubview(bottomLine)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(18)
            make.top.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.right.equalToSuperview().offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.height.equalTo(20)
        }
        
        leftLine.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalTo(0.5)
        }

        rigthLine.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
