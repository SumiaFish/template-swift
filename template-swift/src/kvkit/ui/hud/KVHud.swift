//
//  AppHud.swift
//  xingfuqiao
//
//  Created by mac on 2020/4/26.
//  Copyright © 2020 kv. All rights reserved.
//

import UIKit

import MBProgressHUD

enum KVHudState {
    case loadding(_ text: String?)
    case info(_ text: String?)
    case success(_ text: String?)
    case error(_ text: String?)
    case hide
}

protocol KVHudProtocol: UIView {
    
//    var context: UIView? { get set }
    
    func updateHud(_ state: KVHudState)
    
}

extension KVHudProtocol {
    
//    var context: UIView? { nil }
    
    func updateHud(_ state: KVHudState) {}
}

class KVBaseHud: UIView {
    
//    weak var context: UIView?
    
    var afterDelay: TimeInterval = 2
    var dismissTimeval: TimeInterval = 0
    private var link: CADisplayLink?
        
    deinit {
        link?.invalidate()
        link?.remove(from: .current, forMode: .common)
    }
    
    func showLoadding(_ text: String?) {
        
    }
    
    func showInfo(text: String?) {
        
    }
    
    func showError(text: String?) {
        
        
    }
    
    func showSuccess(_ text: String?) {
        
    }
    
    @objc func hide() {
        
    }
    
    func preventAutoDismiss() {
        dismissTimeval = Date.distantFuture.timeIntervalSince1970
    }
    
    func autoDismiss() {
        let now = Date().timeIntervalSince1970
        dismissTimeval = now + afterDelay
        if link == nil {
            let link = CADisplayLink(target: self, selector: #selector(dismissTimevalChange))
            link.add(to: .current, forMode: .common)
            link.preferredFramesPerSecond = 5
            self.link = link
        }
    }
    
    @objc func dismissTimevalChange() {
        if dismissTimeval == 0 {
            return
        }
        let now = Date().timeIntervalSince1970
        if self.dismissTimeval <= now {
            self.hide()
            self.dismissTimeval = 0
        }
    }
    
}

extension KVBaseHud: KVHudProtocol {
    
    func updateHud(_ state: KVHudState) {
        switch state {
        case .loadding(let text):
            showLoadding(text)
        case .success(let text):
            showSuccess(text)
        case .error(let text):
            showError(text: text)
        case .info(let text):
            showInfo(text: text)
        case .hide:
            hide()
        }
    }
    
}

class KVHud: KVBaseHud {

    private var mbphud: MBProgressHUD?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if self.frame.contains(point) {
            return nil
        }
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let superView = self.superview {
            frame = superView.bounds
        }
        mbphud?.frame = self.bounds
    }
    
    override func showLoadding(_ text: String?) {
        hide()
        setHudStyle()
        mbphud?.mode = .indeterminate
        mbphud?.label.text = text
        mbphud?.show(animated: true)
        preventAutoDismiss()
        alpha = 1
        superview?.bringSubviewToFront(self)
    }
    
    override func showInfo(text: String?) {
        hide()
        setHudStyle()
        mbphud?.mode = .text
        mbphud?.label.text = text
        mbphud?.show(animated: true)
        autoDismiss()
        alpha = 1
        superview?.bringSubviewToFront(self)
    }

    override func showSuccess(_ text: String?) {
        showInfo(text: text)
    }
    
    override func showError(text: String?) {
        showInfo(text: text)
    }
    
    override func hide() {
        mbphud?.hide(animated: false)
        alpha = 0
        superview?.sendSubviewToBack(self)
    }

}

private extension KVHud {
    
    func setHudStyle() {
        let  mbphud = MBProgressHUD.showAdded(to: self, animated: true)
        // hud 样式
        mbphud.contentColor = .white
        mbphud.backgroundColor = .clear
        mbphud.bezelView.style = .solidColor
        mbphud.bezelView.color = UIColor.black.withAlphaComponent(0.5)
        self.mbphud = mbphud
    }
    
}
