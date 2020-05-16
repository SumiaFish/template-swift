//
//  AppHud.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

extension UIView {

    private static var UIViewHudHudKey: Void?
    var hud: KVHudProtocol? {
        set {
            if let hud = self.hud {
                hud.removeFromSuperview()
            }
            objc_setAssociatedObject(self, &UIView.UIViewHudHudKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIView.UIViewHudHudKey) as? KVHudProtocol
        }
    }
    
//    open override func forwardingTarget(for aSelector: Selector!) -> Any? {
//        if let hud = self.hud, hud.responds(to: aSelector) {
//            return hud
//        }
//        return super.forwardingTarget(for: aSelector)
//    }
}


extension UIView {
    
    func useDefaultHud() {
        let view = KVHud()
        addSubview(view)
        hud = view
    }
    
    func useStateViewHud() {
        if let view = AppStateView.loadViewFromNib() {
            addSubview(view)
            hud = view
        }
    }
}


