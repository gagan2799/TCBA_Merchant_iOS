//
//  TMContactUsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 21/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMContactUsVC: UIViewController {
    //MARK: Outlets
    //UITextFields
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    //UITextView
    @IBOutlet weak var txtV: UITextView!
    
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
    //MARK: View Properties
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Contact Us"
        
        txtName.setLeftPaddingPoints(5)
        txtEmail.setLeftPaddingPoints(5)
        
        txtName.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtEmail.font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtV.font                   = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        txtName.text                = GConstant.UserDetails.firstName! + " " + GConstant.UserDetails.lastName!
        txtEmail.text               = GConstant.UserDetails.email
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        let message = self.validateView()
        if message != nil{
            AlertManager.shared.showAlertTitle(title: (message?[GConstant.Param.kError])! ,message: (message?[GConstant.Param.kMessage])!)
        } else {
            callPostContactUsApi()
        }
    }
    
    //MARK: Coustom methods
    func validateView() -> Dictionary<String,String>? {
        var message : Dictionary<String,String>? = nil
        let kError = GConstant.Param.kError
        let kMessage = GConstant.Param.kMessage
        if txtName.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your fullname"]
        } else if txtEmail.text == "" || !txtEmail.text!.isValidEmail() {
            message = [kError: "Incomplete Form", kMessage: GConstant.Message.kEmailTxtFieldMessage]
        } else if txtV.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your comment"]
        }
        return message
    }
    //MARK: Web Api's
    func callPostContactUsApi() {
        /*
         =====================API CALL=====================
         APIName    : PostContactUs
         Url        : "/Feedback/PostContactUs"
         Method     : POST
         Parameters : [ userType    : "",
         fullName    : "",
         email       : "",
         comment     : "" ]
         ===================================================
         */
        self.view.endEditing(true)
        let request             = RequestModal.mUserData()
        request.userType        = "merchant"
        request.fullName        = txtName.text!
        request.email           = txtEmail.text!
        request.comment         = txtV.text!
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostContactUs, parameter: request.toDictionary(),debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success", message: "Thank you. Your contact request has been received. We will be in touch shortly.")
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
                        guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
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
