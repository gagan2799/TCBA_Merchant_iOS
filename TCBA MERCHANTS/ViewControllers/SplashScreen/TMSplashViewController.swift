//
//  TMSplashViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 17/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMSplashViewController: UIViewController {
    
    @IBOutlet weak var vBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateView(view: vBackground)
    }
    override func viewWillAppear(_ animated: Bool) {
        // Hide navigationBar
        self.navigationController?.isNavigationBarHidden = true;
    }
    override func viewDidDisappear(_ animated: Bool) {
        //<---------Set statusbar background color--------->
        UIApplication.shared.statusBarView?.backgroundColor = GConstant.AppColor.orange
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Animation Coustom method
    func animateView(view:UIView){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0, animations: {
                view.alpha = 1.0
                view.isOpaque = false
            }, completion: { _ in
                Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.goToMainController), userInfo: nil, repeats: false)
            })
        }
    }
    //MARK: - Timer Function
    @objc func goToMainController(){
        if UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserDataLogin) != nil {
            GFunction.shared.userLogin()
        } else {
            GFunction.shared.userLogOut(isFromSplash: true)
        }
    }
}
