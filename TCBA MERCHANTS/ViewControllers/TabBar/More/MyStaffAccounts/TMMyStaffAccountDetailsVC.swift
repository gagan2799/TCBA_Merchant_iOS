//
//  TMMyStaffAccountDetailsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

enum typeStaff : String {
    case addStaff   = "Add Staff Account"
    case editStaff  = "Edit Staff Account"
}

class TMMyStaffAccountDetailsVC: UIViewController {
    
    //MARK: Variables & Constants
    var typeStaffAcc    : typeStaff!
    var staffData       : StaffMember!
    
    //MARK: Outlets
    //UILabels
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    
    //UITextFields
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtStore: UITextField!
    
    //UIButton
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnStaffAcc: UIButton!
    //Constraints
    @IBOutlet weak var consHeightContainer: NSLayoutConstraint!
    @IBOutlet weak var consHeightSaveBtn: NSLayoutConstraint!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewProperties()
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
    //MARK: - ViewProperties
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title       = typeStaffAcc != nil ? typeStaffAcc.rawValue : ""
        
        consHeightContainer.constant    = GConstant.Screen.Height * 0.3
        consHeightSaveBtn.constant      = GConstant.Screen.Height * 0.07
        view.layoutIfNeeded()
        
        lblFirstName.font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblLastName.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblPhoneNo.font                 = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblStore.font                   = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        lblFirstName.padding            = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        lblLastName.padding             = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        lblPhoneNo.padding              = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        lblStore.padding                = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        txtFirstName.font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtLastName.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtPhoneNo.font                 = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtStore.font                   = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        txtFirstName.setRightPaddingPoints(10)
        txtLastName.setRightPaddingPoints(10)
        txtPhoneNo.setRightPaddingPoints(10)
        txtStore.setRightPaddingPoints(10)
        
        if typeStaffAcc == .editStaff {
            guard staffData != nil else { return }
            txtFirstName.text           = staffData.firstName
            txtLastName.text            = staffData.lastName
            txtPhoneNo.text             = staffData.phoneNumber
            txtStore.text               = staffData.staffStores[0].storeName
            btnStaffAcc.isHidden        = false
            btnStaffAcc.setTitle(staffData.active ? "Deactivate Staff Account" : "Activate Staff Account", for: .normal)
        } else {
            txtFirstName.text           = ""
            txtLastName.text            = ""
            txtPhoneNo.text             = ""
            txtStore.text               = ""
            btnStaffAcc.isHidden        = true
        }
    }
    
    //MARK: - UIButton Action Mehods
    @IBAction func btnSaveAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let message = self.validateView()
        if (message == nil) {
            typeStaffAcc == .editStaff ? callPutUpdateStaffMemberApi(withSatffAcc: staffData.active ? "true" : "false") : callPostNewStaffMemberApi()
        } else { // Error
            AlertManager.shared.showAlertTitle(title: (message?[GConstant.Param.kError])! ,message: (message?[GConstant.Param.kMessage])!)
        }
    }
    @IBAction func btnStaffAccAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let message = self.validateView()
        if (message == nil) {
//            For Activate/Deactivate account
            callPutUpdateStaffMemberApi(withSatffAcc: staffData.active ? "false" : "true")
        } else { // Error
            AlertManager.shared.showAlertTitle(title: (message?[GConstant.Param.kError])! ,message: (message?[GConstant.Param.kMessage])!)
        }
        
    }
    //MARK: - Custom Methods
    func validateView() -> Dictionary<String,String>? {
        var message : Dictionary<String,String>? = nil
        let kError = GConstant.Param.kError
        let kMessage = GConstant.Param.kMessage
        if txtFirstName.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your FirstName"]
        } else if txtLastName.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your LastName"]
        } else if txtPhoneNo.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your Phone Number"]
        } else if txtStore.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your Store Name"]
        }
        return message
    }
    
    //MARK: - Web Api's
    func callPutUpdateStaffMemberApi(withSatffAcc active: String) {
        /*
         =====================API CALL=====================
         APIName    : PutUpdateStaffMember
         Url        : "/Staff/PutUpdateStaffMember"
         Method     : PUT
         Parameters : {
         "active"       : ""
         "staffMemberId": ""
         "firstName"    : ""
         "lastName"     : ""
         "phoneNumber"  : ""
         "stores"       : ""
                  }
         ===================================================
         */
        
        let request             = RequestModal.mUpdateStoreContent()
        request.active          = active
        request.firstName       = txtFirstName.text
        request.lastName        = txtLastName.text
        request.staffMemberId   = "\(staffData.staffMemberID)"
        request.phoneNumber     = txtPhoneNo.text
        request.stores          = txtStore.text
        
        ApiManager.shared.PUTWithBearerAuth(strURL: GAPIConstant.Url.PutUpdateStaffMember, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success", message: GConstant.Message.kUpdatesSaveMessage)
            } else {
                if let data = data {
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                } else {
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
    
    func callPostNewStaffMemberApi() {
        /*
         =====================API CALL=====================
         APIName    : PostNewStaffMember
         Url        : "/Staff/PostNewStaffMember"
         Method     : POST
         Parameters : { posID   : 123 }
         ===================================================
         */
        let request             = RequestModal.mUpdateStoreContent()
        request.firstName       = txtFirstName.text
        request.lastName        = txtLastName.text
        request.phoneNumber     = txtPhoneNo.text
        request.stores          = txtStore.text
        let url = GAPIConstant.Url.PostNewStaffMember
        
        ApiManager.shared.POSTWithBearerAuth(strURL: url, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard data != nil else{return}
                
            } else {
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            let str = String(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
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
