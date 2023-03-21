//
//  FMFilterView.swift
//  FMAccountBook
//
//  Created by wei peng on 2023/3/15.
//

import UIKit

let kFilterTopSapce = 200.0

class FMFilterView: UIView {
    
    typealias FinishBlock = ((_ minAmount: Double, _ maxAmount: Double, _ categorys: [TradeCategory]) -> Void)
    
    var expenseDatasource = [FMCategoryModel]()
    var incomeDatasource = [FMCategoryModel]()
    var filterCategorys = [TradeCategory]()
    
    var finishBlock: FinishBlock?
    
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
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(resignAction))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)
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
    
    lazy var minTextfiled: FMTextField = {
        let textfiled = FMTextField()
        textfiled.placeholder = "最低金额"
        textfiled.font = .systemFont(ofSize: 14)
        textfiled.textColor = .black
        textfiled.keyboardType = .decimalPad
        textfiled.smartInsertDeleteType = .no // 禁用智能插入和删除
        textfiled.smartQuotesType = .no // 禁用智能引号
        textfiled.smartDashesType = .no // 禁用智能破折号
        textfiled.delegate = self
        return textfiled
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

        view.addSubview(label)
        view.addSubview(minTextfiled)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        minTextfiled.snp.makeConstraints { make in
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
    
    lazy var maxTextfiled: FMTextField = {
        let textfiled = FMTextField()
        textfiled.tag = 0
        textfiled.placeholder = "最高金额"
        textfiled.font = .systemFont(ofSize: 14)
        textfiled.textColor = .black
        textfiled.keyboardType = .decimalPad
        textfiled.smartInsertDeleteType = .no // 禁用智能插入和删除
        textfiled.smartQuotesType = .no // 禁用智能引号
        textfiled.smartDashesType = .no // 禁用智能破折号
        textfiled.delegate = self
        return textfiled
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

        view.addSubview(label)
        view.addSubview(maxTextfiled)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        maxTextfiled.snp.makeConstraints { make in
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
    
    lazy var resetButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("重置", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var finishedButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        return btn
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
    
    @objc func resetAction() {
        expenseDatasource.forEach { $0.selected = false }
        incomeDatasource.forEach { $0.selected = false }
        collectionView.reloadData()
    }
    
    @objc func finishAction() {
        var minAmount = 0.0
        var maxAmount = 0.0
        if (minTextfiled.text?.count ?? 0) > 0 {
            minAmount = Double((minTextfiled.text ?? "0")) ?? 0.0
        }
        if (maxTextfiled.text?.count ?? 0) > 0 {
            maxAmount = Double((maxTextfiled.text ?? "0")) ?? 0.0
        }
        
        if minAmount > maxAmount {
            let alert = FMAlertView(title: "温馨提示", message: "[最低金额]不能大于[最高金额]", cancelTitle: nil)
            if let vc = UIApplication.shared.zy_keyWindow?.rootViewController {
                alert.show(in: vc, style: .alert)
            }
            return
        }
        
        let selectedIncome = incomeDatasource.filter { $0.selected }.map { $0.catetory }
        let selectedExpense = expenseDatasource.filter { $0.selected }.map { $0.catetory }
        let categorys = selectedIncome + selectedExpense
        print(minAmount, maxAmount, categorys)
        dismiss()
        finishBlock?(minAmount, maxAmount, categorys)
    }
    
    @objc func resignAction() {
        UIApplication.shared.zy_keyWindow?.endEditing(true)
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
        contentView.addSubview(resetButton)
        contentView.addSubview(finishedButton)
        
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
            make.left.right.equalToSuperview()
            make.bottom.equalTo(resetButton.snp.top).offset(-10)
        }
        
        resetButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-kSafeAreaInsets.bottom)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        finishedButton.snp.makeConstraints { make in
            make.centerY.equalTo(resetButton)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(150)
            make.height.equalTo(40)
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
        UIApplication.shared.zy_keyWindow?.endEditing(true)
        if indexPath.section == 0 {
            let model = expenseDatasource[indexPath.row]
            model.selected = !model.selected
        } else {
            let model = incomeDatasource[indexPath.row]
            model.selected = !model.selected
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

extension FMFilterView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.collectionView) == true {
            return false
        }
        return true
    }
}

extension FMFilterView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 第一个字符是0时，不允许输入数字，删除和小数点可以
        if textField.text == "0" && (string != "" && string != ".") {
            return false
        }
        // 第一个字符是小数点时
        if string == "." {
            let decimalCount = (textField.text?.components(separatedBy: ".").count ?? 0) - 1
            if decimalCount >= 1 {
                // 不允许输入多个小数点
                return false
            }
            if textField.text?.isEmpty == true {
                // 第一个字符是小数点，自动补0
                textField.text = "0"
            }
        }
        return true
    }
}
