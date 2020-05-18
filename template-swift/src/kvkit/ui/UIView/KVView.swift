//
//  KVView.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//


// MARK: -

protocol KVContextProtocol : NSObject {
    
}

protocol KVViewProtocol : KVContextProtocol {
    
    associatedtype P: KVPresentProtocol
    
    associatedtype C: KVContextProtocol
    
    var present: P? { get set }
    
    var context: C? { get set }

}

protocol KVPresentProtocol : NSObject {
    
    associatedtype V: KVViewProtocol
    
    var view: V? { get set }

}

func KVBind<C: KVContextProtocol, V: KVViewProtocol, P: KVPresentProtocol>(context: C, view: V, present: P) {

    view.context = context as? V.C
    
    view.present = present as? V.P
    
    view.present?.view = view as? V.P.V
}


// MARK: - display

protocol KVViewDisplayProtocol: UIView {
    
    var isDisplay: Bool { get }
    
    func display(_ isDisplay: Bool)
    
}

protocol KVViewDisplayDelegate: NSObject {
    
    func onView(_ view: KVViewDisplayProtocol, _ isDisplay: Bool)
    
}

class KVView: UIView, KVViewDisplayProtocol {

    weak var displayDelegate: KVViewDisplayDelegate?
    
    var isDisplay: Bool { alpha != 0 }
    
    func display(_ isDisplay: Bool) {
        if isDisplay == self.isDisplay {
            return
        }
        if displayDelegate != nil {
            displayDelegate?.onView(self, isDisplay)
        } else {
            alpha = isDisplay ? 1 : 0
        }
        isDisplay ? superview?.bringSubviewToFront(self) : superview?.sendSubviewToBack(self)
        isUserInteractionEnabled = isDisplay
        
        diaplayBackgroundView(isDisplay: isDisplay)
    }
    
    
    var bgv: BackgroundView?

    func useBackgroundView() {
        removeBackgroundView()
        
        bgv = BackgroundView(frame: .zero)
        if let view = bgv {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            view.isUserInteractionEnabled = true
            view.onTap = { [weak self] in
                self?.display(false)
            }
            diaplayBackgroundView(isDisplay: self.isDisplay)
        }
    }
    func removeBackgroundView() {
        bgv?.removeFromSuperview()
        bgv = nil
    }
    private func diaplayBackgroundView(isDisplay: Bool) {
        if let view = self.bgv, let superView = self.superview {
            view.alpha = isDisplay ? 1 : 0
            if isDisplay {
                view.removeFromSuperview()
                superView.insertSubview(view, belowSubview: self)
            } else {
                view.removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let view = self.bgv, let superView = view.superview {
            view.frame = superView.bounds
        }
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        bgv?.removeFromSuperview()
    }
    

}

extension KVView {

    class BackgroundView: UIView {
        
        deinit {
            KLog("\(self.className) dealloc~")
        }
        
        var onTap: ()->Void = {}
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapAction(_:))))
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
                
        @objc func onTapAction(_ sender: UITapGestureRecognizer) {
            onTap()
        }
        
    }
    
}




