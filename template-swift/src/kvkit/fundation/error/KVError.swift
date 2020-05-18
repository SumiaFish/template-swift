//
//  KVError.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

/**
 自定义错误的封装
 */
public struct KVError : Error {
    let msg: String?
    let code: Int?
    let description: String?
    
    init(_ msg: String?) {
        self.msg = msg
        self.code = nil
        self.description = nil
    }
    
    init(msg: String?, code: Int?, _ description: String? = nil) {
        self.msg = msg
        self.code = code
        self.description = description
    }
}
