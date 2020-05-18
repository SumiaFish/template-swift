//
//  HomeViewController.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol HomeTableViewContextProtocol: NSObjectProtocol {
    
    func pushDetail(item: Any)
    
}

protocol HomeTableViewProtocol: HomeTableViewContextProtocol {
    
    var context: HomeTableViewContextProtocol? { get set }
    
    var homePresent: HomePresentProtocol? { get set }
    
}

protocol HomePresentProtocol: KVTableViewPresentProtocol {
    
    var homeTableView: HomeTableViewProtocol? { get set }
    
}

class HomeViewController: AppViewController {
    
    private lazy var tableView: TableView = TableView(frame: .zero, style: .plain)
    
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

/// 在这里做业务操作
private extension HomeViewController {
    
    func initView() {
        view.useStateViewHud()
    }
    
    func initTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.context = self
        let present = Present()
        tableView.present = present
        tableView.homePresent = present
        present.tableView = tableView
        present.homeTableView = tableView
 
//        ??? TODO
        tableView.delegate = self
 
        tableView.hud = view.hud
        
        view.addSubview(tableView)
    }
    
    
    
}

extension HomeViewController: HomeTableViewContextProtocol {
    
    func pushDetail(item: Any) {
        KLog("前往详情页...")
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
}


extension HomeViewController {
    
    class TableView: AppTableView, HomeTableViewProtocol {
        
        weak var context: HomeTableViewContextProtocol?
        
        var homePresent: HomePresentProtocol?
        
        func pushDetail(item: Any) {
            context?.pushDetail(item: item)
        }
        
    }
    
    class Present: KVTableView.Present<[Int]>, HomePresentProtocol {
        
        typealias T = [Int]
        
        weak var homeTableView: HomeTableViewProtocol?
        
        override func loadData(isRefresh: Bool) {
            guard let tableView = self.tableView else {
                return
            }
            let adapater = self
            
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

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            //            let item = adapater.realData[indexPath.section][indexPath.row]
            cell.textLabel?.text = String("\(indexPath.section)"+":"+"\(indexPath.row)")
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            homeTableView?.pushDetail(item: realData[indexPath.section][indexPath.row])
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }

    }

}



