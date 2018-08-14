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
    var memberTransactionData: MemberTransactionDetailsModel!
    
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
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        guard scrQR != nil else {return}
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
        lblStoreId.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: .white, cornerRadius: 2.0, borderColor: .white, borderWidth: 1.0, labelShadow: nil)
        lblStoreId.backgroundColor          = .clear
        lblStoreId.text                     = "Store Id: \(GConstant.UserData.stores ?? "")"
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
    
    //MARK: - UIView Action methods
    @IBAction func vQRAction(_ sender: UIControl) {
        presentQR()
    }
    
    //MARK: - Navigation
    func presentQR() {
        let obj = TMScannerVC()
        obj.completionHandler = { (code) in
            let id = code.replacingOccurrences(of: "http://tcba.mobi/kc/", with: "");   self.callMemberTransactionDetailsApi(code: id)
        }
        self.navigationController?.present(obj, animated: true, completion: {
            print("Presented QR")
        })
    }

    func pushToMemberTransaction(data: MemberTransactionDetailsModel) {
        let obj = storyboard?.instantiateViewController(withIdentifier: "TMMemberTransactionVC") as! TMMemberTransactionVC
        obj.memberTransactionData = data
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
        txtId.text          = ""
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetMemberTransactionDetails, parameter: request.toDictionary(),debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.memberTransactionData  = try! MemberTransactionDetailsModel.decode(_data: data)
                guard self.memberTransactionData != nil else {return}
                self.pushToMemberTransaction(data: self.memberTransactionData)
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
                        let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
                        if let json = json {
                            AlertManager.shared.showAlertTitle(title: "Error" ,message: json["message"] ?? GConstant.Message.kSomthingWrongMessage)
                        }else{
                            AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                        }
                    }else{
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                    }
                }
            }
        }
    }
}
