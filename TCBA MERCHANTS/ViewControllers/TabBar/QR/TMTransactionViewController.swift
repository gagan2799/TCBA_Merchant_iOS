//
//  TMTransactionViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMTransactionViewController: UIViewController {
    //MARK: variables
    var memberTransactionData: MemberTrasactionModal!
    @IBOutlet weak var viewLock: UIView!
    
    //MARK: - Outlets
    @IBOutlet weak var vBGGradient: UIView!
    @IBOutlet weak var vBotmCont: UIView!
    @IBOutlet weak var vQR: UIView!
    @IBOutlet weak var vTxtF: UIView!
    
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblScanCode: UILabel!
    @IBOutlet weak var vSemiCircle: UIView!
    @IBOutlet weak var vSemicircleL: UIView!
    
    @IBOutlet weak var txtId: UITextField!
    
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    
    @IBOutlet weak var scrQR: UIScrollView!
    @IBOutlet weak var consHeightBotmV: NSLayoutConstraint!
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        CompletionHandler.shared.litsenerEvent(.pushToPayment) { (data) in
            guard let pData = data as? PostCreatePOSModel else { return }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                let objPVC          = self.storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.StorePayment) as! TMStorePaymentVC
                objPVC.posData      = pData
                objPVC.typeTable    = .mix
                print(self.navigationController as Any)
                self.navigationController?.pushViewController(objPVC, animated: true)
            })
        }
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtId.text = ""
        
        if UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.EnableStaffMode) == true && UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.isStaffLoggedIn) == false{
            DispatchQueue.main.async {
                self.viewLock.isHidden  = false
            }
        } else {
            DispatchQueue.main.async {
                self.viewLock.isHidden  = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard scrQR != nil else {return}
        if  UIDevice.current.orientation.isLandscape == true  {
            scrQR.isScrollEnabled = true
        }else{
            scrQR.isScrollEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Customer Transaction"
        
        guard scrQR != nil else {   return  }
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrQR.isScrollEnabled = true
        }else{
            scrQR.isScrollEnabled = false
        }
        if  UIDevice.current.userInterfaceIdiom == .pad  {
            consHeightBotmV.constant    = GConstant.Screen.Height * 0.5
        }else{
            consHeightBotmV.constant    = GConstant.Screen.Height * 0.45
        }
        vBotmCont.layoutIfNeeded()
        
        vTxtF.applyStyle(cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 1.0,backgroundColor: .white)
        vBotmCont.applyCornerRadius(cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio)
        vSemiCircle.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 10 : 5)
        vSemicircleL.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 10 : 5)
        
        // Set lbl properties
        lblCashBack.font = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
        lblStoreId.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: .white, cornerRadius: 2.0, borderColor: .white, borderWidth: 1.0)
        lblStoreId.backgroundColor          = .clear
        lblStoreId.text                     = "Store ID: \(GConstant.UserData.stores ?? "")"
        lblOR.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0, isAspectRasio: false), labelColor: GConstant.AppColor.textDark, cornerRadius: lblOR.bounds.midY, borderColor: GConstant.AppColor.textLight, backgroundColor: .white, borderWidth: 1.0)
        lblScanCode.font                    = UIFont.applyOpenSansBold(fontSize: 20.0)
        
        txtId.font                          = UIFont.applyOpenSansRegular(fontSize: 15.0)
        btnSubmitOutlet.titleLabel?.font    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnSubmirAction(_ sender: UIButton) {
        txtId.resignFirstResponder()
        if txtId.text == ""{
            AlertManager.shared.showAlertTitle(title: "Error", message: GConstant.Message.kMemberIDTxtFieldMessage)
        }else{
            callMemberTransactionDetailsApi(code: txtId.text!)
        }
    }
    
    @IBAction func btnLockLogin(_ sender: UIButton) {
        staffLoginVC()
    }
    
    //MARK: - UIView Action methods
    @IBAction func vQRAction(_ sender: UIControl) {
        presentQR()
    }
    
    //MARK: - Navigation
    func presentQR() {
        let obj = TMQRScannerVC()
        obj.completionHandler = { (code) in
            let id = code.replacingOccurrences(of: "http://tcba.mobi/kc/", with: "");   self.callMemberTransactionDetailsApi(code: id)
        }
        self.navigationController?.present(obj, animated: true, completion: {
            print("Presented QR")
        })
    }
    
    func pushToMemberTransaction(data: MemberTrasactionModal) {
        let obj         = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.MemberTransaction) as! TMMemberTransactionVC
        obj.memTranData = data
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    //MARK: Web Api's
    func callMemberTransactionDetailsApi(code:String) {
        /*
         =====================API CALL=====================
         APIName    : GetMemberTransactionDetails
         Url        : "/Payment/POS/GetMemberTransactionDetails"
         Method     : GET
         Parameters : { memberID : 123,
         storeID    : 456 }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        
        if code.isNumeric {
            request.memberID        = code
        } else {
            request.keyChainCode    = code
        }
        
        request.storeID     = storeId
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetMemberTransactionDetails, parameter: request.toDictionary(),debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                self.txtId.text = ""
                guard let mData  = data else{return}
                if let memData  = try? MemberTrasactionModal.decode(_data: mData) {
                    self.memberTransactionData = memData
                    self.pushToMemberTransaction(data: self.memberTransactionData)
                } else {
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            } else if statusCode == 400 {
                print("status code is 400")
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                }
            } else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
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
    //MARK: CheckStaffLogin Method & Api
    func staffLoginVC() {
        let obj = storyboard?.instantiateViewController(withIdentifier: "TMStaffLoginVC") as! TMStaffLoginVC
        obj.userT = .staff
        obj.modalPresentationStyle = .overCurrentContext
        obj.completionHandler   = { (pin) in
            self.callGetStaffLoginApi(pin: pin)
        }
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    func callGetStaffLoginApi(pin: String) {
        /*
         =====================API CALL=====================
         APIName    : GetStaffLogin
         Url        : "/Staff/GetStaffLogin"
         Method     : GET
         Parameters : { storeID : "", pinCode : "" }
         ===================================================
         */
        let request = RequestModal.mCreatePOS()
        guard let storeId = GConstant.UserData.stores else{return}
        request.storeId = storeId
        request.pinCode = pin
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStaffLogin, parameter: request.toDictionary(), withLoader : false) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("Correct PIN")
                DispatchQueue.main.async {
                    self.viewLock.isHidden  = true
                    UserDefaults.standard.set(true, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
                    UserDefaults.standard.synchronize()
                }
            }else{
                AlertManager.shared.showAlertTitle(title: "Incorrect PIN" ,message:"Your pin is incorrect, please try again.")
            }
        }
    }
}
