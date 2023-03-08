//
//  FMAddVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit

let width = kScreenWidth / 5.0

class FMAddVC: UIViewController {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "交易金额"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var monkeyLabel: UILabel = {
        let label = UILabel()
        label.text = "¥"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var textfield: UITextField = {
        let view = UITextField()
        view.placeholder = "0.00"
        view.font = .systemFont(ofSize: 30, weight: .medium)
        view.textColor = .black
        view.keyboardType = .decimalPad
        return view
    }()
    
    lazy var incomeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .lightGray.withAlphaComponent(0.5)
        btn.setTitle("收入", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.red, for: .selected)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    lazy var expenseButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .lightGray.withAlphaComponent(0.5)
        btn.setTitle("支出", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.red, for: .selected)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(FMCategoryCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIColor.createImage(color: .red), for: .normal)
        btn.setTitle("确定添加", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "记一笔"
        view.backgroundColor = .color(hex: "#F6F6F6")
//        navigationItem.hidesBackButton = true
        makeUI()
        addNoti()
    }
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(textfiledDidChanged), name: UITextField.textDidChangeNotification, object: nil)
    }

    func makeUI() {
        view.addSubview(topView)
        view.addSubview(categoryView)
        view.addSubview(bottomView)
        topView.addSubview(titleLabel)
        topView.addSubview(monkeyLabel)
        topView.addSubview(textfield)
        categoryView.addSubview(incomeButton)
        categoryView.addSubview(expenseButton)
        categoryView.addSubview(collectionView)
        bottomView.addSubview(confirmButton)
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        categoryView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50+kSafeAreaInsets.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        monkeyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(20)
            make.left.equalTo(titleLabel)
            make.width.equalTo(40)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        textfield.snp.makeConstraints { make in
            make.left.equalTo(monkeyLabel.snp.right).offset(20)
            make.centerY.equalTo(monkeyLabel)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(monkeyLabel)
        }
        
        incomeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        expenseButton.snp.makeConstraints { make in
            make.left.equalTo(incomeButton.snp.right).offset(10)
            make.centerY.equalTo(incomeButton)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(incomeButton.snp.bottom).offset(20)
            make.height.equalTo(130)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
    }
}

extension FMAddVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FMCategoryCell
        cell.textLabel.text = "\(indexPath.row)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(width, 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension FMAddVC {
    @objc func textfiledDidChanged() {
        confirmButton.isEnabled = (textfield.text?.count ?? 0) > 0
    }
}

extension FMAddVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textfield.resignFirstResponder()
    }
}
