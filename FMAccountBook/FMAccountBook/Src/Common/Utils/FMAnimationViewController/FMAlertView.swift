//
//  FMAlertView.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import UIKit

class FMAlertView: FMBaseAnimationView {
    
    var cancelTitle: String?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var horLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cacnelAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var spaceLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        makeUI()
    }
    
    convenience init(title: String?, message: String?, cancelTitle: String?, doneTitle: String = "确定") {
        self.init(frame: .zero)
        self.cancelTitle = cancelTitle
        titleLabel.text = title ?? ""
        contentLabel.text = message ?? ""
        if let title =  cancelTitle {
            cancelButton.setTitle(title, for: .normal)
        }
        doneButton.setTitle(doneTitle, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cacnelAction() {
        dismiss()
    }
    
    @objc func doneAction() {
        dismiss()
    }
    
    func makeUI() {
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(horLine)
        addSubview(cancelButton)
        addSubview(spaceLine)
        addSubview(doneButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(titleLabel)
        }
        
        horLine.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        if cancelTitle == nil {
            doneButton.snp.makeConstraints { make in
                make.top.equalTo(horLine.snp.bottom)
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(40)
            }
        } else {
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(horLine.snp.bottom)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(40)
            }
            
            doneButton.snp.makeConstraints { make in
                make.right.bottom.equalToSuperview()
                make.width.equalTo(cancelButton)
                make.right.equalTo(cancelButton.snp.right)
            }
            
            spaceLine.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(0.5)
                make.height.equalTo(40)
            }
        }
    }
    
}
