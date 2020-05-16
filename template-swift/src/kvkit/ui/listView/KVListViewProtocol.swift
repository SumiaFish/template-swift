//
//  KVListViewProtocol.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVTableViewPresentProtocol: NSObjectProtocol {
        
    func loadData(tableView: KVTableViewProrocol, isRefresh: Bool)
    
}

protocol KVTableViewAdapterProtocol: UITableViewDataSource {
        
    var data: [Any] { get }
    
    var hasMore: Bool { get }
    
    var page: Int { get }

    var onRenderSections: ((_ data: [Any])->Int)? { set get }
    
    var onRenderRows: ((_ section: Int, _ data: [Any])->Int)? { set get }
    
    var onRenderCell: ((_ indexPath: IndexPath, _ data: [Any])->UITableViewCell)? { set get }
    
    func update(data: [Any], page: Int, hasMore: Bool)

}

enum KVTableViewState {

    case loadding
    case success(adapter: KVTableViewAdapterProtocol)
    case error(error: KVError)
}

protocol KVTableViewProrocol: NSObjectProtocol {
        
    var adapter: KVTableViewAdapterProtocol? { get }
        
    var present: KVTableViewPresentProtocol? { get }

    func refresh(_ showRefreshCompoent: Bool)
    
    func loadMore(_ showRefreshCompoent: Bool)
    
    func updateState(state: KVTableViewState)
    
}
