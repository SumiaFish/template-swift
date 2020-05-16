//
//  KVTableViewPresent.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVTableViewPresent: NSObject, KVTableViewPresentProtocol {
    func loadData(tableView: KVTableViewProrocol, isRefresh: Bool) {
        guard let adapter = tableView.adapter else {
            return
        }
        
        tableView.updateState(state: .loadding)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let succ = true
            if succ {
                adapter.update(data: [], page: 0, hasMore: false)
                tableView.updateState(state: .success(adapter: adapter))
            } else {
                tableView.updateState(state: .error(error: KVError("加载出错")))
            }
        }
        
    }
    
}
