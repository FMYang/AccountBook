//
//  FMFilterView.swift
//  FMAccountBook
//
//  Created by wei peng on 2023/3/15.
//

import UIKit

let kFilterTopSapce = 200.0

class FMFilterView: UIView {
    
    var expenseDatasource = [FMCategoryModel]()
    var incomeDatasource = [FMCategoryModel]()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tapGes)
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRectMake(0, kFilterTopSapce, kScreenWidth, kScreenHeight-kFilterTopSapce))
        view.backgroundColor = bgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "选择筛选条件"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "金额"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var minAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "¥"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        
        let textfiled = UITextField()
        textfiled.placeholder = "最低金额"
        textfiled.font = .systemFont(ofSize: 14)
        textfiled.textColor = .black
        textfiled.keyboardType = .decimalPad

        view.addSubview(label)
        view.addSubview(textfiled)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        textfiled.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var spaceLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var maxAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "¥"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        
        let textfiled = UITextField()
        textfiled.placeholder = "最高金额"
        textfiled.font = .systemFont(ofSize: 14)
        textfiled.textColor = .black
        textfiled.keyboardType = .decimalPad
        
        view.addSubview(label)
        view.addSubview(textfiled)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        textfiled.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "分类"
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        view.backgroundColor = bgColor
        view.dataSource = self
        view.delegate = self
        view.register(FMFilterItemCell.self, forCellWithReuseIdentifier: "cell")
        view.register(FMFilterHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.register(FMFilterFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        view.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let expenseCategorys: [TradeCategory] = [.dining, .travel, .redEnvelope, .rent, .entertainment, .payment, .shopping, .transferToOther, .clothing, .daily]
        let incomeCategorys: [TradeCategory] = [.salary, .fund, .refund, .transferFromOthers, .bond, .cash, .reimbursement, .redEnvelope]
        expenseDatasource = FMCategoryModel.datasouce(data: expenseCategorys)
        incomeDatasource = FMCategoryModel.datasouce(data: incomeCategorys)
        expenseDatasource.forEach { $0.selected = false }
        incomeDatasource.forEach { $0.selected = false }
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        contentView.zy_y = kScreenHeight
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.contentView.zy_y = kFilterTopSapce
        }, completion: { finish in
            super.willMove(toSuperview: newSuperview)
        })
    }
    
    override func removeFromSuperview() {
        contentView.zy_y = kFilterTopSapce
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.contentView.zy_y = kScreenHeight
        }, completion: { finish in
            super.removeFromSuperview()
        })
    }
    
    @objc func dismiss() {
        removeFromSuperview()
    }
    
    func makeUI() {
        addSubview(bgView)
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(minAmountView)
        contentView.addSubview(spaceLabel)
        contentView.addSubview(maxAmountView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(collectionView)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        spaceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(minAmountView)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        minAmountView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(10)
            make.left.equalTo(amountLabel)
            make.width.equalTo(0.5*(kScreenWidth-80))
            make.height.equalTo(30)
        }
        
        maxAmountView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(0.5*(kScreenWidth-80))
            make.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(minAmountView.snp.bottom).offset(30)
            make.left.equalTo(minAmountView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension FMFilterView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return expenseDatasource.count
        } else {
            return incomeDatasource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FMFilterItemCell
        if indexPath.section == 0 {
            cell.config(model: expenseDatasource[indexPath.row])
        } else {
            cell.config(model: incomeDatasource[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            expenseDatasource.forEach { $0.selected = false }
            var model = expenseDatasource[indexPath.row]
            model.selected = true
        } else {
            incomeDatasource.forEach { $0.selected = false }
            var model = incomeDatasource[indexPath.row]
            model.selected = true
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kScreenWidth - 80) / 3
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! FMFilterHeaderView
            if indexPath.section == 0 {
                header.titleLabel.text = "支出"
            } else {
                header.titleLabel.text = "收入"
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            return footer
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 20.0)
    }
}
