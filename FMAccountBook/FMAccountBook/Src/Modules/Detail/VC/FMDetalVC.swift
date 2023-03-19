//
//  FMDetalVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit
import DatabaseVisual
import KafkaRefresh

class FMDetalVC: UIViewController {
    
    var viewModel = FMDetailViewModel()
    var month = Calendar.currentMonth() ?? 1
    var year = Calendar.currentYear() ?? 2023
    
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
    
    lazy var toolView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.03"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var arrowImageView1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "downward-arrow")
        return view
    }()
    
    lazy var dateButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(dateAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "筛选"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var arrowImageView2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "downward-arrow")
        return view
    }()
    
    lazy var filterButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
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
        return view
    }()
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        let label = UILabel()
        label.textColor = UIColor.gray.withAlphaComponent(0.5)
        label.text = "暂无数据，快来记一笔"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "收支"
        makeUI()
        addLongPressGes()
        bindViewModel()
        loadData()
        configRefresh()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    func bindViewModel() {
        viewModel.listDataChangedBlock = { [weak self] in
            self?.emptyView.isHidden = (self?.viewModel.listData.count ?? 0) > 0 ? true : false
            self?.tableView.reloadData()
        }
    }
    
    func loadData() {
        viewModel.fetchData(year: year, month: month)
    }
    
    func configRefresh() {
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.loadData()
            self?.tableView.headRefreshControl?.endRefreshing()
            self?.tableView.footRefreshControl?.endRefreshing()
        })
        
        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.viewModel.fetchMoreData(completion: { [weak self] in
                self?.tableView.headRefreshControl?.endRefreshing()
                self?.tableView.footRefreshControl?.endRefreshing()
            })
        })
    }
    
    @objc func addAction() {
        let vc = FMAddVC()
        vc.hidesBottomBarWhenPushed = true
        vc.addBlock = { [weak self] in
            self?.loadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dateAction() {
        let dateView = FMDatePickerView(frame: UIScreen.main.bounds)
        dateView.confirmBlock = { [weak self] year, month, day in
            self?.year = year
            self?.month = month
            let text = String(format: "%04d.%02d", year, month)
            self?.dateLabel.text = text
            self?.loadData()
        }
        UIApplication.shared.zy_keyWindow?.addSubview(dateView)
    }
    
    @objc func filterAction() {
        let filterView = FMFilterView(frame: UIScreen.main.bounds)
        filterView.finishBlock = { [weak self] minAmount, maxAmount, categorys in
            self?.viewModel.fetchData(minAmount: minAmount, maxAmount: maxAmount, categorys: categorys)
        }
        UIApplication.shared.zy_keyWindow?.addSubview(filterView)
    }
    
    func makeUI() {
        view.addSubview(toolView)
        toolView.addSubview(dateLabel)
        toolView.addSubview(arrowImageView1)
        toolView.addSubview(dateButton)
        toolView.addSubview(filterLabel)
        toolView.addSubview(arrowImageView2)
        toolView.addSubview(filterButton)
        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(addButton)
        
        toolView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        arrowImageView1.snp.makeConstraints { make in
            make.left.equalTo(dateLabel.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        dateButton.snp.makeConstraints { make in
            make.left.equalTo(dateLabel)
            make.right.equalTo(arrowImageView1.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
        arrowImageView2.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        filterLabel.snp.makeConstraints { make in
            make.right.equalTo(arrowImageView2.snp.left).offset(-5)
            make.top.bottom.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.left.equalTo(filterLabel)
            make.right.equalTo(arrowImageView2)
            make.top.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(toolView.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
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
        return 30.0
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
}
