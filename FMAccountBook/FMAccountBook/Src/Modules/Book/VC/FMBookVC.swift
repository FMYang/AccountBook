//
//  FMBookVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit

class FMBookVC: UIViewController {
    
    let viewModel = FMBookViewModel()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        view.register(FMBookCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        navigationItem.title = "我的账本"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItem?.tintColor = .black
        bindViewModel()
        makeUI()
        loadData()
    }
    
    func bindViewModel() {
        viewModel.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func loadData() {
        viewModel.query()
    }
    
    @objc func addAction() {
        let alert = FMAddBookAlert(title: "添加账本")
        alert.confirmBlock = { [weak self] text in
            self?.viewModel.addBook(name: text)
            self?.loadData()
        }
        alert.show(in: self, style: .alert)
    }
    
    func makeUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FMBookVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FMBookCell
        cell.config(model: viewModel.data(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        }
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewModel.datasource.count - 1 {
            return 0.0
        }
        return 10.0
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.delete(indexPath: indexPath)
    }
}
