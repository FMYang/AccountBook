//
//  FMDetalVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit
import DatabaseVisual

class FMDetalVC: UIViewController {
    
    var viewModel = FMDetailViewModel()
    var month = Calendar.currentMonth() ?? 1
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "icon_add"), for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = .zero
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 8
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(FMDetailCell.self, forCellReuseIdentifier: "cell")
        view.register(FMDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        view.register(FMDetalFooterView.self, forHeaderFooterViewReuseIdentifier: "footer")
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "收支"
        makeUI()
        addLongPressGes()
        bindViewModel()
        loadData()
    }
    
    func bindViewModel() {
        viewModel.listDataChangedBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func loadData() {
        let month = String(format: "%02d", month)
        viewModel.fetchData(month: month)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    @objc func addAction() {
        let vc = FMAddVC()
        vc.hidesBottomBarWhenPushed = true
        vc.addBlock = { [weak self] in
            self?.loadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeUI() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}

extension FMDetalVC {
    func addLongPressGes() {
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPressGes.minimumPressDuration = 2
        navigationController?.navigationBar.addGestureRecognizer(longPressGes)
    }
    
    @objc func longPressAction() {
        DatabaseManager.sharedInstance().showTables()
    }
}

extension FMDetalVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FMDetailCell
        cell.config(model: viewModel.listModel(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! FMDetailHeaderView
        view.config(model: viewModel.headerModel(section: section))
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 134.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.delete(indexPath: indexPath)
        self.loadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = bgColor
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! FMDetailHeaderView
        headerView.contentView.backgroundColor = bgColor
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        headerView.layer.masksToBounds = true
        headerView.layer.isOpaque = true
        headerView.layer.cornerRadius = 8
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footerView = view as! UITableViewHeaderFooterView
        footerView.contentView.backgroundColor = bgColor
        footerView.layer.borderWidth = 0.5
        footerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        footerView.layer.masksToBounds = true
        footerView.layer.isOpaque = true
        footerView.layer.cornerRadius = 5
        footerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    }
}
