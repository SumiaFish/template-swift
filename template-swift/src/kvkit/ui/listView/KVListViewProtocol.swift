//
//  KVListViewProtocol.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

//protocol KVTableViewContextProtocol: NSObjectProtocol {
//
//    var controller: UIViewController? { get }
//
//    var tableView: KVTableViewProrocol? { get set }
//
//    var present: KVTableViewPresentProtocol? { get set }
//
//    var render: KVTableViewRenderProtocol? { get set }
//
//    var adapter: KVTableViewAdapterProtocol? { get set }
//
//    init(_ controller: UIViewController)
//
//}

protocol KVTableViewAdapterProtocol: UITableViewDataSource {
        
    typealias T = Any
    
    var tableView: KVTableViewProrocol? { get set }
        
    var data: [T] { get }
        
    var hasMore: Bool { get }
    
    var page: Int { get }
    
    func update(data: [T], page: Int, hasMore: Bool)
    
    func updateView()

}

protocol KVTableViewRenderProtocol: KVTableViewAdapterProtocol, UITableViewDelegate {

}

protocol KVTableViewPresentProtocol: KVTableViewRenderProtocol {
            
    func loadData(isRefresh: Bool)
    
}

enum KVTableViewState {

    case loadding
    case success
    case error(error: KVError)
}

protocol KVTableViewProrocol: UITableView {
        
    var present: KVTableViewPresentProtocol? { get set }

    func refresh(_ showRefreshCompoent: Bool)
    
    func loadMore(_ showRefreshCompoent: Bool)
    
    func updateState(state: KVTableViewState)
    
}
