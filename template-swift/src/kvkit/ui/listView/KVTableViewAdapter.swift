//
//  KVTableViewAdapter.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVTableViewAdapter<ItemType: Any>: NSObject, KVTableViewAdapterProtocol {

    typealias T = Any

    var data: [T] = []
    
    var realData: [ItemType] {
        return data.filter { (it) -> Bool in
            return it is ItemType
        }.map { (it) -> ItemType in
            return it as! ItemType
        }
    }
    
    var hasMore: Bool = false
    
    var page: Int = 1
    
    var onRenderCell: ((IndexPath, [Any]) -> UITableViewCell)?
    
    var onRenderSections: (([Any]) -> Int)?
    
    var onRenderRows: ((Int, [Any]) -> Int)?
    
    func update(data: [T], page: Int, hasMore: Bool) {
        self.data = data
        self.page = page
        self.hasMore = hasMore
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return onRenderSections?(data) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onRenderRows?(section, data) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return onRenderCell?(indexPath, data) ?? UITableViewCell()
    }
    

}
