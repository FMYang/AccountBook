//
//  FMAccountSelectView.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import UIKit
import SnapKit

class FMAccountSelectView: UIView {
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tapGes)
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 300))
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.text = "请选择账本"
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismiss() {
        removeFromSuperview()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        containerView.zy_y = kScreenHeight
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.containerView.zy_y = kScreenHeight - 300
        }, completion: { finish in
            super.willMove(toSuperview: newSuperview)
        })
    }
    
    override func removeFromSuperview() {
        containerView.zy_y = kScreenHeight - 300
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.containerView.zy_y = kScreenHeight
        }, completion: { finish in
            super.removeFromSuperview()
        })
    }

    func makeUI() {
        addSubview(contentView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(tableView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
    }
}

extension FMAccountSelectView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "hello"
        if indexPath.row == 0 {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
}
