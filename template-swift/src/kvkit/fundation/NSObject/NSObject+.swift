//
//  NSObject+.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

extension NSObject {
    // MARK:返回className
    var className:String{
        get{
          let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }

        }
    }
    
    static var className:String{
        get{
            let name =  String(describing: type(of: Self.self))
            if(name.contains(".Type")){
                return name.components(separatedBy: ".Type")[0];
            }else{
                return name;
            }

        }
    }
    
    var fullClassName: String {
        get{
          return type(of: self).description()
        }
    }

}
