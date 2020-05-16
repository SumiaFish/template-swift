//
//  KVTableViewContext.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

extension KVTableView {
    
    class Context: NSObject, KVTableViewContextProtocol {
        
        required init(_ controller: UIViewController) {
            self.controller = controller
        }
        
        weak var controller: UIViewController?
        
        weak var tableView: KVTableViewProrocol? {
            didSet {
                tableView?.context = self
                tableView?.dataSource = adapter
                tableView?.delegate = render
            }
        }
    
        var adapter: KVTableViewAdapterProtocol? {
            didSet {
                adapter?.context = self
                tableView?.dataSource = adapter
            }
        }
        
        var present: KVTableViewPresentProtocol? {
            didSet {
                present?.context = self
                adapter = present
            }
        }
        
        var render: KVTableViewRenderProtocol? {
            didSet {
                render?.context = self
                tableView?.delegate = render
            }
        }
        
    }
    
}

