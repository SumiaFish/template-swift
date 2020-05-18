//
//  LiveRoomViewController.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class LiveRoomViewController: AppViewController {

    override var navigationBarNeedHidden: Bool { true }
    
    private lazy var chooseView = GiftChooseView.loadViewFromNib()!
    
    private lazy var toolView = LiveRoomToolView.loadViewFromNib()!
    
    private lazy var closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initCloseButton()
        initToolView()
        initChooseView()
    }
    
}

private extension LiveRoomViewController {
    
    func initView() {
        view.useStateViewHud()
    }
    
    func initChooseView() {
        view.addSubview(chooseView)
        chooseView.useBackgroundView()
        chooseView.useStateViewHud()
        chooseView.displayDelegate = self
        
        chooseView.context = self
        chooseView.present = GiftChooseViewPresent()

        UIView.performWithoutAnimation {
            chooseView.display(false)
        }
    }
    
    func initToolView() {
        view.addSubview(toolView)
        toolView.context = self
        
        let h: CGFloat = 200
        let w: CGFloat = 50
        let x: CGFloat = self.view.bounds.width-w-20
        let y: CGFloat = view.bounds.height-h-20
        toolView.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func initCloseButton() {
        view.addSubview(closeButton)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.onClick { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        var top: CGFloat = 20
        if getIsIPhonexSerious() {
            if #available(iOS 11.0, *) {
                top = view.safeAreaInsets.top + 20
            }
        }
        let h: CGFloat = 50
        let w: CGFloat = 100
        let x: CGFloat = self.view.bounds.width-w
        let y: CGFloat = top
        closeButton.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func layoutChooseView(_ isDisplay: Bool) {

        var bot: CGFloat = 0
        if getIsIPhonexSerious() {
            if #available(iOS 11.0, *) {
                bot = view.safeAreaInsets.bottom
            }
        }
        let h: CGFloat = 300
        let w: CGFloat = view.bounds.width
        let x: CGFloat = 0
        let y: CGFloat = isDisplay ? view.bounds.height-h-bot : view.bounds.height
        chooseView.frame = CGRect(x: x, y: y, width: w, height: h)

    }
    
}

extension LiveRoomViewController: KVViewDisplayDelegate {
    
    func onView(_ view: KVViewDisplayProtocol, _ isDisplay: Bool) {
        if view == chooseView {
            UIView.animate(withDuration: 0.3) {
                self.layoutChooseView(isDisplay)
                self.chooseView.alpha = isDisplay ? 1 : 0
            }
        }
    }
    
}

extension LiveRoomViewController: GiftChooseViewContextProtocol {

    func send(gift: Gift) {
        MsgManager.sharedInstance.sendMsg(msg: GiftMsg(id: UUID().uuidString, text: "\(gift.username ?? "")送出\(gift.name ?? "")", gift: gift, receiveTime: Date().timeIntervalSince1970))
    }

}


extension LiveRoomViewController: LiveRoomToolViewContextProtocol {
    
    func toggleChooseViewDisplayState() {
        chooseView.display(!chooseView.isDisplay)
    }
    
}


