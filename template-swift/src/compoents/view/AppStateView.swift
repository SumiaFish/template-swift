//
//  AppStateView.swift
//  template-swift
//
//  Created by kevin on 2020/5/15.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class AppStateView: KVBaseHud {

    var dismissLableWhenTap = true {
        didSet {
            bg.isUserInteractionEnabled = dismissLableWhenTap
        }
    }
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var lable: UILabel!
        
    private let paragraphStyle = NSMutableParagraphStyle()
    private let bg = UIView()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == bg {
            return bg
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        activity.isUserInteractionEnabled = false
        
        lable.isHidden = true
        lable.text = ""
        paragraphStyle.lineSpacing = 100 - (lable.font.lineHeight-lable.font.pointSize)
        lable.backgroundColor = .clear
        lable.textColor = .white
        lable.isUserInteractionEnabled = false
        
        insertSubview(bg, belowSubview: lable)
        bg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bg.layer.cornerRadius = 4
        bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgTapAction(_:))))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let superView = self.superview {
            frame = superView.bounds
        }
        
        let val: CGFloat = 8;
        bg.frame = CGRect(x: lable.frame.minX-val, y: lable.frame.minY-val, width: lable.frame.width+val*2, height: lable.frame.height+val*2)
    }
    
    @objc func bgTapAction(_ sender: UITapGestureRecognizer) {
        bg.isHidden = true
    }
    
    override func showLoadding(_ text: String?) {
        lable.isHidden = true
        bg.isHidden = true
        activity.startAnimating()
        preventAutoDismiss()
        alpha = 1
        superview?.bringSubviewToFront(self)
    }
    
    override func showInfo(text: String?) {
        activity.stopAnimating()
        lable.isHidden = false
        bg.isHidden = text == nil || false
        setText(text: text)
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
        super.hide()
        activity.stopAnimating()
        lable.isHidden = true
        bg.isHidden = true
        alpha = 0
        superview?.sendSubviewToBack(self)
    }
}

private extension AppStateView {
    
    func setText(text: String?) {
        if let text = text {
            lable.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
}
