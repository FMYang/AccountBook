//
//  FMDetalVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit
import DatabaseVisual

class FMDetalVC: UIViewController {
    
    var datasource: [FMRecord] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        title = "收支"
        makeUI()
        addLongPressGes()
        loadData()
        querySum()
    }
    
    func querySum() {
        asyncCall {
            // 总支出
            DBManager.shared.dbQueue?.inDatabase({ db in
                let sql = "select sum(tradeAmount) as total_amount from \(FMRecord.tableName) where strftime('%m', date) = '03' and tradeType = 1"
                do {
                    let ret = try db.executeQuery(sql, values: nil)
                    while ret.next() {
                        let amount = ret.double(forColumn: "total_amount")
                        print("amount = \(amount)")
                    }
                } catch {
                    print(error)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    func loadData() {
        asyncCall { [weak self] in
            // 查询3月数据
            DBManager.query(object: FMRecord.self, condition: "strftime('%m', date) = '03'", orderBy: "date", isDesc: true) { [weak self] records in
                DispatchQueue.main.async {
                    if let data = records as? [FMRecord] {
                        self?.datasource = data
                    }
                }
            }
        }
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FMDetailCell
        cell.config(model: datasource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 114.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        FMCoreData.shared.delete(entity: datasource[indexPath.row])
//        datasource.remove(at: indexPath.row)
//        tableView.reloadData()
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
        headerView.config()
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
