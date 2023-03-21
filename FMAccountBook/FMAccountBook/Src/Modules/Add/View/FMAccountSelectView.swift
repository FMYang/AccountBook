//
//  FMAccountSelectView.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/20.
//

import UIKit
import SnapKit

class FMAccountSelectView: UIView {
    
    var confirmBlock: (([Int])->())?
    
    let viewModel = FMAccountSelectViewModel()
    
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
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.text = "请选择账本"
        return label
    }()
    
    lazy var donebutton: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return btn
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
        bindViewModel()
        viewModel.query()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismiss() {
        removeFromSuperview()
    }
    
    @objc func doneAction() {
        confirmBlock?(viewModel.selectedIds())
        dismiss()
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
    
    func bindViewModel() {
        viewModel.loadDataBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func makeUI() {
        addSubview(contentView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(donebutton)
        containerView.addSubview(tableView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        donebutton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
    }
}

extension FMAccountSelectView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let model = viewModel.datasource[indexPath.row]
        cell.textLabel?.text = model.account.name
        cell.accessoryType = model.selected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.datasource[indexPath.row]
        model.selected = !model.selected
        tableView.reloadData()
    }
}
