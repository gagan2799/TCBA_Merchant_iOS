//
//  TMMoreViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 31/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title = "More"
//        GConstant.NavigationController = self.navigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - UIButton Action methods
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        AlertManager.shared.showAlertTitle(title: "Logout", message: "Are you sure you want to logout?", buttonsArray: ["Cancel","Logout"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                GFunction.shared.userLogOut()
                break
            default:
                break
            }
        }
    }
}
