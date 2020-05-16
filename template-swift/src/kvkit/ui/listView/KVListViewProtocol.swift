//
//  KVListViewProtocol.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol KVTableViewContextProtocol: NSObjectProtocol {

    var controller: UIViewController? { get }
    
    var tableView: KVTableViewProrocol? { get set }
    
    var adapter: KVTableViewAdapterProtocol? { get set }
        
    var present: KVTableViewPresentProtocol? { get set }
    
    var render: KVTableViewRenderProtocol? { get set }
    
    init(_ controller: UIViewController)
    
}

protocol KVTableViewPresentProtocol: KVTableViewAdapterProtocol {
    
    var context: KVTableViewContextProtocol? { get set }
            
    func loadData(isRefresh: Bool)
    
}

protocol KVTableViewAdapterProtocol: UITableViewDataSource {
        
    typealias T = Any
    
    var context: KVTableViewContextProtocol? { get set }
        
    var data: [T] { get }
        
    var hasMore: Bool { get }
    
    var page: Int { get }
    
    func update(data: [T], page: Int, hasMore: Bool)
    
    func updateView()

}

protocol KVTableViewRenderProtocol: UITableViewDelegate {
    
    var context: KVTableViewContextProtocol? { get set }

}

enum KVTableViewState {

    case loadding
    case success
    case error(error: KVError)
}

protocol KVTableViewProrocol: UITableView {
        
    var context: KVTableViewContextProtocol? { get set }

    func refresh(_ showRefreshCompoent: Bool)
    
    func loadMore(_ showRefreshCompoent: Bool)
    
    func updateState(state: KVTableViewState)
    
}
