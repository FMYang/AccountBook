//
//  FMAddBookAlert.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import UIKit
import SnapKit

class FMAddBookAlert: FMBaseAnimationView {
    
    var confirmBlock: ((String)->())?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var textBgView: UIView = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var textfiled: UITextField = {
        let view = UITextField()
        view.placeholder = "请输入账本名"
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        return view
    }()
    
    lazy var horLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var spaceLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(selectedColor, for: .normal)
        btn.addTarget(self, action: #selector(done), for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        return btn
    }()

    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setupSubViews()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func done() {
        if textfiled.text?.isEmpty == false {
            confirmBlock?(textfiled.text ?? "默认账本")
        }
        self.dismiss()
    }

    @objc func cancel() {
        self.dismiss()
    }
    
    func setupSubViews() {
        addSubview(titleLabel)
        addSubview(textBgView)
        addSubview(textfiled)
        addSubview(horLine)
        addSubview(cancelButton)
        addSubview(spaceLine)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        textBgView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        textfiled.snp.makeConstraints { make in
            make.edges.equalTo(textBgView).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
        
        horLine.snp.makeConstraints { make in
            make.top.equalTo(textBgView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(horLine.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(doneButton)
            make.height.equalTo(40)
        }
        
        spaceLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(cancelButton)
            make.width.equalTo(0.5)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton)
            make.left.equalTo(cancelButton.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
}

