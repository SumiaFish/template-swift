//
//  AppTabbarController.swift
//  template-swift
//
//  Created by kevin on 2020/5/16.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

class AppTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeNav = AppNavigationController(rootViewController: HomeViewController())
        homeNav.title = "首页"
        
        let liveNav = AppNavigationController(rootViewController: LiveViewController())
        liveNav.title = "直播"
        
        let imNav = AppNavigationController(rootViewController: ImViewController())
        imNav.title = "消息"
        
        let personalNav = AppNavigationController(rootViewController: PersonalViewController())
        personalNav.title = "我的"
        
        viewControllers = [homeNav, liveNav, imNav, personalNav]
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
