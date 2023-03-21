//
//  FMBookDetailVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/21.
//

import UIKit

class FMBookDetailVC: UIViewController {
    
    let viewModel = FMBookDetailViewModel()
    var accountModel: FMAccount?

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(FMDetailCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    convenience init(model: FMAccount) {
        self.init(nibName: nil, bundle: nil)
        accountModel = model
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = accountModel?.name

        bindViewModel()
        makeUI()

        if let id = accountModel?.account_id {
            viewModel.query(accountId: id)
        }
    }

    func bindViewModel() {
        viewModel.loadDataBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func makeUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FMBookDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FMDetailCell
        cell.bottomLine.isHidden = false
        cell.config(model: viewModel.model(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
