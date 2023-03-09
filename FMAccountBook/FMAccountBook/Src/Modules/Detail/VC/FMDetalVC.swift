//
//  FMDetalVC.swift
//  FMAccountBook
//
//  Created by yfm on 2023/3/8.
//

import UIKit
import DatabaseVisual

class FMDetalVC: UIViewController {
    
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
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(FMDetailCell.self, forCellReuseIdentifier: "cell")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "收支"
        makeUI()
        addLongPressGes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.red
    }
    
    @objc func addAction() {
        let vc = FMAddVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeUI() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FMDetailCell
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
