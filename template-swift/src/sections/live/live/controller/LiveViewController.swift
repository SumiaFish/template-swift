//
//  LiveViewController.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class LiveViewController: AppViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton(type: .system)
        view.addSubview(btn)
        btn.setTitle("去直播间", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        btn.center = view.center
        btn.addTarget(self, action: #selector(pushLiveRoom(_:)), for: .touchUpInside)
    }
    
    @objc func pushLiveRoom(_ sender: UIButton) {
        let live = LiveRoomViewController()
        navigationController?.pushViewController(live, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
