//
//  HomePresent.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class HomePresent: NSObject {

    var data: [[Int]] = []
    
}

extension HomePresent: KVTableViewPresentProtocol {
    
    func loadData(tableView: KVTableViewProrocol, isRefresh: Bool) {
        guard let adapater = tableView.adapter else {
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
            tableView.updateState(state: .success(adapter: adapater))
        }
    }
    
}
