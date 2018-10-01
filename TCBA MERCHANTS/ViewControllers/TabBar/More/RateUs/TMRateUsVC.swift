//
//  TMRateUsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 21/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import Cosmos

class TMRateUsVC: UIViewController {
    
    //MARK: Outlets
    //UITextFields
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    //UITextView
    @IBOutlet weak var txtV: UITextView!
    //UILable
    @IBOutlet weak var lblRateUs: UILabel!
    @IBOutlet weak var lblLovedIt: UILabel!
    //Constraints
    @IBOutlet weak var consHeightMainView: NSLayoutConstraint!
    //StarRating
    @IBOutlet weak var starRating: CosmosView!
    
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
        self.navigationItem.title   = "Rate Us"
        
        consHeightMainView.constant = GConstant.Screen.Height * 0.8
        self.view.layoutIfNeeded()
        
        txtName.setLeftPaddingPoints(5)
        txtEmail.setLeftPaddingPoints(5)
        
        txtName.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtEmail.font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtV.font                   = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblRateUs.font              = UIFont.applyOpenSansRegular(fontSize: 20.0)
        lblLovedIt.font             = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        txtName.text                = GConstant.UserDetails.firstName! + " " + GConstant.UserDetails.lastName!
        txtEmail.text               = GConstant.UserDetails.email
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        let message = self.validateView()
        if message != nil{
            AlertManager.shared.showAlertTitle(title: (message?[GConstant.Param.kError])! ,message: (message?[GConstant.Param.kMessage])!)
        } else {
            callPostRateUsApi()
        }
    }
    
    //MARK: Coustom methods
    func validateView() -> Dictionary<String,String>? {
        var message : Dictionary<String,String>? = nil
        let kError = GConstant.Param.kError
        let kMessage = GConstant.Param.kMessage
        if txtV.text == "" {
            message = [kError: "Incomplete Form", kMessage: "Please enter your feedback."]
        }
        return message
    }
    //MARK: Web Api's
    func callPostRateUsApi() {
        /*
         =====================API CALL=====================
         APIName    : PostRateUs
         Url        : "/Feedback/PostRateUs"
         Method     : POST
         Parameters : [ message : "",
         rating  : "" ]
         ===================================================
         */
        let request             = RequestModal.mUserData()
        request.message         = txtV.text!
        request.rating          = "\(Int(starRating.rating))"
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostRateUs, parameter: request.toDictionary(),debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                //FIXME:If Condition on Rating
                if self.starRating.rating.isLessThanOrEqualTo(3){
                    AlertManager.shared.showAlertTitle(title: "", message: "Thanks for your valuable feedback. We will take your comments into consideration.")
                } else {
                    AlertManager.shared.showAlertTitle(title: "", message: "Thanks for your valuable feedback. We would appreciate if you could give your feedback on App Store also.", buttonsArray: ["No, Thanks","Ok"]) { (buttonIndex : Int) in
                        switch buttonIndex {
                        case 0 :
                            //No clicked
                            self.navigationController?.popToRootViewController(animated: true)
                            break
                        case 1:
                            UIApplication.shared.open(URL(string:GConstant.kAppStoreLink)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                            break
                        default:
                            break
                        }
                    }
                }
            }else{
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
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
