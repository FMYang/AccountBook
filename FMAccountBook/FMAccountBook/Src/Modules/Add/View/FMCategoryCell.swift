//
//  FMCategoryCell.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit

class FMCategoryCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(imageView)
        addSubview(textLabel)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(25)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
