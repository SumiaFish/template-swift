//
//  KVTableViewAdapter.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

extension KVTableView {

    class Adapter<ItemType: Any>: NSObject, KVTableViewAdapterProtocol {
        
        weak var tableView: KVTableViewProrocol?
        
        var data: [T] = []
                
        var realData: [ItemType] = []
        
        var hasMore: Bool = false
        
        var page: Int = 1

        var sections: Int = 1
        
        var rowsMap: [Int: Int] = [:]
        
        override init() {
            sections = 1
            rowsMap[0] = 0
        }

        // MARK: -

        func numberOfSections(in tableView: UITableView) -> Int {
            return sections
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rowsMap[section] ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
        // MARK: -
        
        func update(data: [T], page: Int, hasMore: Bool) {
            self.data = data
            self.page = page
            self.hasMore = hasMore
            
            realData.removeAll()
//            let f = data.map { (it) -> ItemType in
//                return it as! ItemType
//            }
            realData.append(contentsOf: data.filter({ $0 is ItemType }).map({ $0 as! ItemType }))
        }
        
        func updateView() {
            let adapter = self
            
            //
            var newSections = 0
            var newRowsMap: [Int: Int] = [:]
            if let data = adapter.data as? [[Any]] {
                newSections = data.count
                for i  in 0..<newSections {
                    if data.count > i {
                        newRowsMap[i] = data[i].count
                    }
                }
            } else {
                newSections = 1
                newRowsMap[0] = adapter.data.count
            }

            //
            sections = newSections
            rowsMap = newRowsMap
            //
            tableView?.reloadData()
        }

    }
    
    class Render<ItemType: Any>: Adapter<ItemType>, KVTableViewRenderProtocol {
        
        // MARK: -

        
        
    }
    
}
