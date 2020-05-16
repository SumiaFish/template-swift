//
//  KVTableView.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class KVTableView: UITableView  {
    
    override var mj_header: MJRefreshHeader? {
        set {
            newValue?.refreshingBlock = { [weak self] in
                self?.refresh(true)
            }
            super.mj_header = newValue
        }
        get {
            return super.mj_header
        }
    }
    
    override var mj_footer: MJRefreshFooter? {
        set {
            newValue?.refreshingBlock = { [weak self] in
                self?.loadMore(true)
            }
            newValue?.isHidden = true
            super.mj_footer = newValue
        }
        get {
            return super.mj_footer
        }
    }
    
    var adapter: KVTableViewAdapterProtocol? {
        didSet {
            dataSource = adapter
        }
    }
    
    var present: KVTableViewPresentProtocol?
    
    var render: Render?
    
    var onReloadData: (_ tableView: KVTableView)->Void = { tableView in
        tableView.updateRows()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        tableFooterView = UIView()
        render = Render(self)
    }
    
    // MARK: -
    
    func useDefaultHeader() {
        mj_header = MJRefreshNormalHeader(refreshingBlock: {})
    }
    
    func useDefaultFooter() {
        mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {})
    }
    
}

private extension KVTableView {
    
    func loadData(isRefresh: Bool) {
        present?.loadData(tableView: self, isRefresh: isRefresh)
    }
    
    func reloadData(adapter: KVTableViewAdapterProtocol) {
        self.adapter = adapter
        onReloadData(self)
    }
    
    func updateRows() {
        render?.update()
    }
}

extension KVTableView {
    
    class Render: NSObject {
    
        var sections: Int = 1
        
        var rowsMap: [Int: Int] = [:]
        
        weak var tableView: KVTableView?

        init(_ tableView: KVTableView?) {
            self.tableView = tableView
        }
        
        func update() {
            guard let tableView = self.tableView, let adapter = tableView.adapter else {
                sections = 1
                rowsMap[0] = 0
                return
            }
            
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
            adapter.onRenderRows = { section,_ in
                return newRowsMap[section] ?? 0
            }
            adapter.onRenderSections = { _ in
                return newSections
            }
            //
            tableView.reloadData()
            //
            sections = newSections
            rowsMap = newRowsMap

//            //
//            if newSections > 1 {
//                adapter.onRenderRows = { section,_ in
//                    return newRowsMap[section] ?? 0
//                }
//                adapter.onRenderSections = { _ in
//                    return newSections
//                }
//                //
//                tableView.reloadData()
//                //
//                sections = newSections
//                rowsMap = newRowsMap
//                return
//            }
//
//            //
//            let currentSections = sections
//            var currentRowsMap = rowsMap
//            for i in 0..<currentSections {
//                currentRowsMap[i] = rowsMap[i]
//                if currentRowsMap[i]==nil {
//                    currentRowsMap[i] = 0
//                }
//            }
//            
//            adapter.onRenderRows = { section,_ in
//                return newRowsMap[section] ?? 0
//            }
//            adapter.onRenderSections = { _ in
//                return newSections
//            }
//
//            if let rows = currentRowsMap[0], let newRows = newRowsMap[0] {
//                
//                if rows != newRows {
//                    var arr: [IndexPath] = []
//                    let isInsert = rows<newRows
//                    
//                    if isInsert {
//                        for j in 0..<abs(newRows-rows) {
//                            arr.append(IndexPath(row: rows+j, section: 0))
//                        }
//                    } else {
//                        for j in 0..<abs(newRows-rows) {
//                            arr.append(IndexPath(row: rows-j-1, section: 0))
//                        }
//                    }
//                    
//                    if arr.count > 0 {
//                        UIView.performWithoutAnimation {
//                            if isInsert {
//                                tableView.insertRows(at: arr, with: .bottom)
//                            } else {
//                                tableView.deleteRows(at: arr, with: .bottom)
//                            }
//                        }
//                    }
//                }
//
//            }
//            
//            if let arr = tableView.indexPathsForVisibleRows, arr.count > 0 {
//                UIView.performWithoutAnimation {
//                    tableView.reloadRows(at: arr, with: .bottom)
//                }
//            }
//            
//            //
//            sections = newSections
//            rowsMap = newRowsMap
            
        }
        
    }
    
}

extension KVTableView: KVTableViewProrocol {
    
    func refresh(_ showRefreshCompoent: Bool) {
        if showRefreshCompoent {
            if let header = self.mj_header, header.isRefreshing == false {
                header.beginRefreshing()
            } else {
                loadData(isRefresh: true)
            }
        }
    }
    
    func loadMore(_ showRefreshCompoent: Bool) {
        if showRefreshCompoent {
            if let footer = self.mj_footer, footer.isRefreshing == false {
                footer.beginRefreshing()
            } else {
                loadData(isRefresh: false)
            }
        }
    }
    
    func updateState(state: KVTableViewState) {
        switch state {
        case .loadding:
            hud?.updateHud(.loadding("加载中..."))
        case .success(let adapter):
            hud?.updateHud(.success("加载成功"))
            reloadData(adapter: adapter)
            mj_header?.endRefreshing()
            mj_footer?.endRefreshing()
            mj_footer?.isHidden = (indexPathsForVisibleRows?.count == 0)
            if adapter.hasMore == false {
                mj_footer?.endRefreshingWithNoMoreData()
            } else {
                mj_footer?.state = .idle
            }
        case .error(_):
            hud?.updateHud(.error("加载失败"))
            mj_header?.endRefreshing()
            mj_footer?.endRefreshing()
        }
    }

}
