//
//  UIViewCategary.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

extension UIView {
    
    static func loadViewFromNib() -> Self? {
        return Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)?.last as? Self
    }
    
}
