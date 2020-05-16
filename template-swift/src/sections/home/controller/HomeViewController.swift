//
//  HomeViewController.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class HomeViewController: AppViewController {
    
    private lazy var tableView: TableView = TableView(frame: .zero, style: .plain)

    private lazy var context = Context(self)
    
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
        
        context.tableView = tableView
                
        tableView.hud = view.hud
        
        view.addSubview(tableView)
    }
    
}

extension HomeViewController {
    
    class Context: KVTableView.Context {
        
        required init(_ controller: UIViewController) {
            super.init(controller)            
            present = Present()
        }
        
    }
    
    class TableView: AppTableView {
        
        
        
    }
    
    class Present: KVTableView.Present<[[Int]]> {
        
        typealias T = [[Int]]
        
        override func loadData(isRefresh: Bool) {
            guard let tableView = context?.tableView, let adapater = context?.adapter else {
                return
            }
            
            tableView.updateState(state: .loadding)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let page = isRefresh ? 1 : adapater.page + 1
                let hasMore = self.data.count <= 10
                if isRefresh {
                    self.data.removeAll()
                }
                if hasMore {
                    var arr: [Int] = []
                    for _ in 0..<5 {
                        for i in self.data.count..<self.data.count+10 {
                            arr.append(i)
                        }
                    }
                    self.data.append(arr)
                    
                }
                adapater.update(data: self.data, page: page, hasMore: hasMore)
                tableView.updateState(state: .success)
            }
        }
        
        override func updateView() {
            super.updateView()
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            //            let item = adapater.realData[indexPath.section][indexPath.row]
            cell.textLabel?.text = String("\(indexPath.section)"+":"+"\(indexPath.row)")
            return cell
        }

    }
    
    class Render: KVTableView.Render {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        
    }
    
}



