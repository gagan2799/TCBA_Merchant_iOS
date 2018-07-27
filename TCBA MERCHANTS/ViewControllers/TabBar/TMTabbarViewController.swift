//
//  TMTabbarViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import ESTabBarController_swift

enum Tabbar {
    static func coustomTabBar() -> ESTabBarController {
        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = TMHomeViewController()
        let v2 = TMHomeViewController()
        let v3 = TMHomeViewController()
        let v4 = TMHomeViewController()
        let v5 = TMHomeViewController()
        
        v1.tabBarItem = ESTabBarItem.init(title: "Home", image: UIImage(named: "home_on"), selectedImage: UIImage(named: "home_on"))
        v2.tabBarItem = ESTabBarItem.init(title: "History", image: UIImage(named: "tab_history"), selectedImage: UIImage(named: "tab_history"))
        v3.tabBarItem = ESTabBarItem.init(title: "QR", image: UIImage(named: "tab_qr"), selectedImage: UIImage(named: "tab_qr"))
        v4.tabBarItem = ESTabBarItem.init(title: "Share", image: UIImage(named: "share_on"), selectedImage: UIImage(named: "share_on"))
        v5.tabBarItem = ESTabBarItem.init(title: "More", image: UIImage(named: "more_on"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }
}
