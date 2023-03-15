//
//  FMFilterItemCell.swift
//  FMAccountBook
//
//  Created by wei peng on 2023/3/15.
//

import UIKit

class FMFilterItemCell: UICollectionViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.text = "退款"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: FMCategoryModel) {
        titleLabel.text = model.catetory.title
        titleLabel.textColor = model.selected ? selectedColor : .black
        bgView.backgroundColor = model.selected ? selectedColor.withAlphaComponent(0.2) : .lightGray.withAlphaComponent(0.3)
    }
    
    func makeUI() {
        addSubview(bgView)
        addSubview(titleLabel)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
}
