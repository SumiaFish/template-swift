//
//  AppTableView.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class AppTableView: KVTableView {

    override func commonInit() {
        super.commonInit()

        useDefaultHeader()
        useDefaultFooter()
        present = KVTableViewPresent()
        adapter = KVTableViewAdapter<Any>()
    }
    
}
