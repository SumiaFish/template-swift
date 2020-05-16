//
//  HomeViewController.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class HomeViewController: AppViewController {
    
    private lazy var tableView: AppTableView = AppTableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableView()
        
        tableView.mj_header?.beginRefreshing()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
}

private extension HomeViewController {
    
    func initView() {
        view.useStateViewHud()
    }
    
    func initTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let present = HomePresent()
        tableView.present = present
        
        let adapater = HomeTableViewAdapater()
        adapater.onRenderCell = { [weak self] indexPath, data in
            let cell = self?.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            let item = adapater.realData[indexPath.section][indexPath.row]
            cell!.textLabel?.text = String("\(indexPath.section)"+":"+"\(indexPath.row)")
            return cell!
        }

        tableView.adapter = adapater
        
        tableView.hud = view.hud
        
        view.addSubview(tableView)
    }
    
}

private extension HomeViewController {
    
    class HomeTableViewAdapater: KVTableViewAdapter<[Int]> {
                        
    }
    
}
