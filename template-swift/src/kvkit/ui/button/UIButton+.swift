//
//  UIButton+.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class a {
    
}

extension UIButton {
    
    private static var UIButtonClickHandlerKey: Void?
    private var onClickHandler: ((_ sender: UIButton)->Void)? {
        set {
            objc_setAssociatedObject(self, &UIButton.UIButtonClickHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton.UIButtonClickHandlerKey) as? (UIButton) -> Void
        }
    }
    
    func onClick(_ block: ((_ sender: UIButton)->Void)? = nil) {
        onClickHandler = block
        self.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
    }
    
    @objc func clickAction(_ sender: UIButton) {
        onClickHandler?(sender)
    }
    
}
