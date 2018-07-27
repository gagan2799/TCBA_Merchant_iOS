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
        // Hide navigationBar
        self.navigationController?.isNavigationBarHidden = true;
        self.animateView(view: vBackground)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //<---------Set statusbar background color--------->
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.949000001, green: 0.4629999995, blue: 0.1180000007, alpha: 1)      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Animation Coustom method
    func animateView(view:UIView){
        UIView.transition(with: view, duration: 3.0, options: [.transitionCrossDissolve], animations: {
            view.backgroundColor = #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7921568627, alpha: 1).withAlphaComponent(1.0)
            view.isOpaque = false
        }){ (true) in
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.goToMainController), userInfo: nil, repeats: false)
        }
    }
    
    //MARK: - Timer Function
    @objc func goToMainController(){
        if UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserData) != nil {
            GFunction.shared.userLogin(isFromSplash: true)
        } else {
            GFunction.shared.userLogOut(isFromSplash: true)
        }
    }
}
