//
//  TMLoginViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 11/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import MessageUI
class TMLoginViewController: UIViewController, MFMailComposeViewControllerDelegate {
    //MARK: - Outlets
    var isFromSplash = Bool()
    
    //<--------UITextfield Outlets--------->
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPopEmailPassword: UITextField!
    @IBOutlet weak var txtPopEmailUser: UITextField!
    
    //<--------UIView Outlets--------->
    // Forgot username view
    @IBOutlet weak var vForgotUsername: UIView!
    @IBOutlet weak var vPopUpUser: UIView!
    // Forgot password view
    @IBOutlet weak var vForgotPassword: UIView!
    @IBOutlet weak var vPopUpPassword: UIView!
    
    //<---------UIImageView Outlets-------->
    @IBOutlet weak var ivPopUserLogo: UIImageView!
    @IBOutlet weak var ivPopPassLogo: UIImageView!
    
    //<---------UIButton Outlets-------->
    @IBOutlet weak var btnSaveUsername: UIButton!
    @IBOutlet weak var btnForgotUserOutlet: UIButton!
    @IBOutlet weak var btnForgotPassOutlet: UIButton!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide the default back buttons if is from splashViewController
        self.navigationItem.hidesBackButton = true
        // Show navigationBar
        GConstant.NavigationController?.isNavigationBarHidden = false;
        self.setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userName = UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserName) {
            txtUsername.text = userName as? String
            btnSaveUsername.isSelected = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        //<--------Fogot user & password buttons Attributes setup----->
        // create attributed string
        let attributes = [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.2310000062, green: 0.2310000062, blue: 0.2310000062, alpha: 1) , NSAttributedStringKey.font: UIFont.applyRegular(fontSize: 12.0) , NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        
        let strTitleForgotUser = "Forgot Username "
        let strAttrUser = NSAttributedString(string: strTitleForgotUser, attributes: attributes)
        btnForgotUserOutlet.setAttributedTitle(strAttrUser, for: .normal)
        
        let strTitleForgotPassword = " Forgot Password"
        let strAttrPassword = NSAttributedString(string: strTitleForgotPassword, attributes: attributes)
        btnForgotPassOutlet.setAttributedTitle(strAttrPassword, for: .normal)
        
        //<----------PopUp Forgot UserName-------->
        vPopUpUser.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7.0 * GConstant.Screen.HeightAspectRatio : 5.0)
        txtPopEmailUser.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: #colorLiteral(red: 0.2310000062, green: 0.2310000062, blue: 0.2310000062, alpha: 1), cornerRadius: nil, borderColor: #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7921568627, alpha: 1), borderWidth: 1.0)
        txtPopEmailUser.setLeftPaddingPoints(10)
        ivPopUserLogo.applyStyle(cornerRadius: 3.0, borderColor: UIColor.white, borderWidth: 2.0)
        
        //<----------PopUp Forgot Password-------->
        vPopUpPassword.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7.0 * GConstant.Screen.HeightAspectRatio : 5.0)
        txtPopEmailPassword.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: #colorLiteral(red: 0.2310000062, green: 0.2310000062, blue: 0.2310000062, alpha: 1), cornerRadius: nil, borderColor: #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7921568627, alpha: 1), borderWidth: 1.0)
        txtPopEmailPassword.setLeftPaddingPoints(10)
        ivPopPassLogo.applyStyle(cornerRadius: 3.0, borderColor: UIColor.white, borderWidth: 2.0)
    }
    
    //MARK: - Animation Coustom method
    func animateHideShow(view:UIView){
        UIView.transition(with: view, duration: 0.5, options: [.showHideTransitionViews,.transitionCrossDissolve], animations: {
            if view.isHidden == false{
                view.isHidden = true
            }
            else{
                view.isHidden = false
            }
        }, completion: nil)
    }
    
    //MARK: - Mail Composer
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["merchants@thecashbackapp.com"])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    //MARK: - Mail Composer Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //MARK: - UIButton Actions
    @IBAction func btnSaveUsernameAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let message = self.validateView()
        if (message == nil) {
            let requestModel = RequestModal.mUserData()
            requestModel.username   = txtUsername.text!
            requestModel.password   = txtPassword.text!
            requestModel.grant_type = "password"
            requestModel.client_id  = "tcba_iphone"
            requestModel.device_id  = GFunction.shared.getDeviceId()
            callLoginUserAPI(requestModel)
            
        } else { // Error
            AlertManager.shared.showAlertTitle(title: message?[GConstant.Param.kError]! ,message: message?[GConstant.Param.kMessage]!)
        }
    }
    
    @IBAction func btnForgotUsernameAction(_ sender: UIButton) {
        txtPopEmailUser.text = ""
        self.animateHideShow(view: vForgotUsername)
    }
    
    @IBAction func btnForgotPasswordAction(_ sender: UIButton) {
        txtPopEmailPassword.text = ""
        self.animateHideShow(view: vForgotPassword)
    }
    
    @IBAction func btnContactAction(_ sender: UIButton) {
        // Calling email composer
        self.sendEmail()
    }
    
    @IBAction func btnSendUserNAction(_ sender: UIButton) {
        if txtPopEmailUser.text == "" || !txtPopEmailUser.text!.isValidEmail() {
            AlertManager.shared.showAlertTitle(title: "Error", message: GConstant.Message.kEmailTxtFieldMessage)
        } else {
            self.animateHideShow(view: vForgotUsername)
            let requestModel = RequestModal.mUserData()
            requestModel.email   = txtPopEmailUser.text
            callForgotUserAPI(requestModel)
        }
    }
    
    @IBAction func btnSendPasswordAction(_ sender: UIButton) {
        if txtPopEmailPassword.text == "" || !txtPopEmailPassword.text!.isValidEmail() {
            AlertManager.shared.showAlertTitle(title: "Error", message: GConstant.Message.kEmailTxtFieldMessage)
        } else {
            self.animateHideShow(view: vForgotPassword)
            let requestModel = RequestModal.mUserData()
            requestModel.username   = txtPopEmailPassword.text
            callForgotPasswordAPI(requestModel)
        }
    }
    
    @IBAction func actionVForgetUser(_ sender: UIControl) {
        self.animateHideShow(view: vForgotUsername)
    }
    
    @IBAction func actionVForgotPassword(_ sender: UIControl) {
        self.animateHideShow(view: vForgotPassword)
    }
    
    //MARK: - Web Api's
    func callLoginUserAPI(_ requestModel : RequestModal.mUserData) {
        /*
         =====================API CALL=====================
         APIName    : Login
         Url        : "/token"
         Method     : POST
         Parameters : { grant_type  : password
         username    : ""
         password    : ""
         client_id   : tcba_iphone
         device_id   : "" }
         ===================================================
         */
        
        ApiManager.shared.POST(strURL: GAPIConstant.Url.Login, parameter: requestModel.toDictionary(), debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if error.isEmpty || data != nil{
                if statusCode == 200 {
                    GFunction.shared.saveUserDetailInDefaults(data!)
                    if self.btnSaveUsername.isSelected{
                        UserDefaults.standard.set(self.txtUsername.text, forKey: GConstant.UserDefaultKeys.UserName)
                        UserDefaults.standard.synchronize()
                    }
                    if (self.navigationController?.viewControllers.first?.isKind(of: TMLoginViewController.self))! {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                        GFunction.shared.userLogin()
                    }
                }else{
                    if statusCode == 404{
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                    }else{
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : String]
                        guard let strError = json!["error"] else {return}
                        guard let strDescription = json!["error_description"] else {return}
                        AlertManager.shared.showAlertTitle(title: strError ,message: strDescription)
                    }
                }
            }else{
                AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
            }
        }
    }
    
    func callForgotUserAPI(_ requestModel : RequestModal.mUserData) {
        /*
         =====================API CALL=====================
         APIName    : ForgotUser
         Url        : "/Users/GetForgotUsername"
         Method     : GET
         Parameters : { email : abc@xyz.com }
         ===================================================
         */
        
        ApiManager.shared.GET(strURL: GAPIConstant.Url.ForgotUsername, parameter: requestModel.toDictionary(), debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success!" ,message:GConstant.Message.kEmailSentSuccessMessage)
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:"User with provided details does not exist")
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
    
    func callForgotPasswordAPI(_ requestModel : RequestModal.mUserData) {
        /*
         =====================API CALL=====================
         APIName    : ForgotUser
         Url        : "Users/GetForgotPassword"
         Method     : GET
         Parameters : { username : anyUsername }
         ===================================================
         */
        
        ApiManager.shared.GET(strURL: GAPIConstant.Url.ForgotPassword, parameter: requestModel.toDictionary(), debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success!" ,message:GConstant.Message.kEmailSentSuccessMessage)
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:"User with provided details does not exist")
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
}
//MARK: - UITxtField delegates And Methods
extension TMLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername {
            txtPassword.becomeFirstResponder()
        }else{
            txtPassword.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
    }
    
    func validateView() -> Dictionary<String,String>? {
        var message : Dictionary<String,String>? = nil
        let kError = GConstant.Param.kError
        let kMessage = GConstant.Param.kMessage
        if txtUsername.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your username to login"]
        } else if txtPassword.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your password to login"]
        }
        return message
    }
    
}
