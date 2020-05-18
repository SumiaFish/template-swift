//
//  LiveRoomToolView.swift
//  template-swift
//
//  Created by kevin on 2020/5/17.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

protocol LiveRoomToolViewContextProtocol: NSObject {
    
    func toggleChooseViewDisplayState()
    
}

class LiveRoomToolView: UIView {

    weak var context: LiveRoomToolViewContextProtocol?
    
    @IBAction func showGiftAction(_ sender: Any) {
        context?.toggleChooseViewDisplayState()
    }
    
}
