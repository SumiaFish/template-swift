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
    
    var present: KVTableViewPresentProtocol? {
        didSet {
            present?.tableView = self
            dataSource = present
            delegate = present
        }
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
        present?.loadData(isRefresh: isRefresh)
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
            hud?.show(.loadding("加载中..."))
        case .success:
            hud?.show(.success("加载成功"))
            present?.updateView()
            mj_header?.endRefreshing()
            mj_footer?.endRefreshing()
            mj_footer?.isHidden = (indexPathsForVisibleRows?.count == 0)
            if present?.hasMore == false {
                mj_footer?.endRefreshingWithNoMoreData()
            } else {
                mj_footer?.state = .idle
            }
        case .error(_):
            hud?.show(.error("加载失败"))
            mj_header?.endRefreshing()
            mj_footer?.endRefreshing()
        }
    }

}
