//
//  KVViewController.swift
//  xingfuqiao
//
//  Created by mac on 2020/4/25.
//  Copyright © 2020 kv. All rights reserved.
//

import UIKit

class KVViewController : UIViewController {
    
    private(set) var navigationBarNeedHidden = false
    
    override var prefersStatusBarHidden: Bool { false }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {.lightContent}
    
    deinit {
        // 这里不能用 self.xxx
        /**
         self.xxx会 == nil，会导致崩溃
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(self.navigationBarNeedHidden, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = self.navigationBarNeedHidden
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(!self.navigationBarNeedHidden, animated: animated)
    }
}
