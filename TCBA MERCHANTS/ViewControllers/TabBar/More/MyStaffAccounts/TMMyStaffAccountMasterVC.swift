//
//  TMMyStaffAccountMasterVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMyStaffAccountMasterVC: UIViewController {

    //MARK: Variables & Constants
    var staffMembersData:GetStaffMemberModel!
    
    
    //MARK: Outlets
    //UITableView
    @IBOutlet weak var tblStaff: UITableView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "My Staff Accounts"
    }
    
    //MARK: - UIButton Action methods
    
    //MARK: - Web Api's
    func GetStaffMembersApi() {
        
        /*
         =====================API CALL=====================
         APIName    : GetStaffMembers
         Url        : "/Staff/GetStaffMembers"
         Method     : GET
         Parameters : nil
         ===================================================
         */
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStaffMembers, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let mData         = data else{return}
                self.staffMembersData   = GetStaffMemberModel.decodeData(_data: mData).response
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data {
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                            AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                            return
                        }
                        print(json as Any)
                        AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                    }else{
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                    }
                }
            }
        }
    }
}
