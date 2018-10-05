//
//  AppDelegate.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 11/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        //<---------Set statusbar color--------->
//        UIApplication.shared.statusBarStyle = .lightContent
        var preferredStatusBarStyle : UIStatusBarStyle {
            return .lightContent
        }
        //<---------Enable IQKeybord---------->
        IQKeyboardManager.shared.enable = true;
        
        //------------------Navigation Controller-------------
        GConstant.NavigationController = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: "RootNavigation") as? UINavigationController
        window?.rootViewController = GConstant.NavigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //MARK: - Custom Methods
    func getCurrentViewController() -> UIViewController {
        if UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserDataLogin) != nil {
            let tabBar = rootWindow().rootViewController as! UITabBarController
            let selectedNavigationController = tabBar.viewControllers![tabBar.selectedIndex] as! UINavigationController
            return selectedNavigationController.visibleViewController!
        } else {
            let selectedNavigationController = rootWindow().rootViewController as! UINavigationController
            return selectedNavigationController.visibleViewController!
        }
    }
}

func appDelegate()->AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
func rootWindow()->UIWindow {
    return appDelegate().window!
}
