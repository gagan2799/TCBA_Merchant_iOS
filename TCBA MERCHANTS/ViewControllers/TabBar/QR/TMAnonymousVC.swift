//
//  TMAnonymousVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 19/12/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAnonymousVC: UIViewController {

    //MARK: Modals
    var cardId      : String!
    var posData     : PostCreatePOSModel!
    
    //MARK: Outlets
    // UIImageView
    @IBOutlet weak var imgVUser: RoundedImage!
    // UILabels
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lbCardId: UILabel!
    @IBOutlet weak var lblCBPurchase: UILabel!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    //UITextfield
    @IBOutlet weak var txtAmount: UITextField!
    //UIButton
    @IBOutlet weak var btnConfirmOutlet: UIButton!
    //ScrollView
    @IBOutlet weak var scrV: UIScrollView!
    //Constraints
    @IBOutlet weak var consMainVHeight: NSLayoutConstraint!
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard scrV != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrV.isScrollEnabled = true
        }else{
            scrV.isScrollEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtAmount.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard scrV != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrV.isScrollEnabled = true
        }else{
            scrV.isScrollEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Anonymous Transaction"
        
        txtAmount.applyStyle(cornerRadius: nil, borderColor: GConstant.AppColor.textLight, borderWidth: 1.0,backgroundColor: GConstant.AppColor.grayBG)
        txtAmount.font                      = UIFont.applyOpenSansRegular(fontSize: 15.0)
        btnConfirmOutlet.titleLabel?.font   = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblUserName.font                    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblCBPurchase.font                  = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblPlaceHolder.font                 = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        lbCardId.text                       = "Card ID: \(cardId ?? "")"
        
        txtAmount.keyboardType              = UIDevice.current.userInterfaceIdiom == .pad ? .numbersAndPunctuation : .numberPad
        
        consMainVHeight.constant            = GConstant.Screen.Height * 0.9
        view.setNeedsLayout()
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnConfirmAction(_ sender: UIButton) {
        txtAmount.resignFirstResponder()
        if txtAmount.text == "" || txtAmount.text == "$0.00" {
            AlertManager.shared.showAlertTitle(title: "", message: "Please enter purchase amount")
        } else {
            guard let amount = txtAmount.text?.replacingOccurrences(of: "$", with: "") else {return}
            callPostInsertStoreCardApi(amount: amount, keychainCode: cardId)
        }
    }
    
    //MARK: Web Api's
    func callPostInsertStoreCardApi(amount:String, keychainCode: String) {
        /*
         =====================API CALL=====================
         APIName    : PostInsertStoreCard
         Url        : "/Transaction/PostInsertStoreCard"
         Method     : POST
         Parameters : { staffId : 0, storeID : 19, TotalAmount : 3.65, KeyChainCode : 19 }
         ===================================================
         */
        let request             = RequestModal.mCreatePOS()
        guard let storeId       = GConstant.UserData?.stores else{return}
        
        request.keyChainCode    = "\(keychainCode)"
        request.storeId         = storeId
        request.staffId         = 0
        request.totalAmount     = amount
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostInsertStoreCard, parameter: request.toDictionary(),debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            self.txtAmount.text = ""
            guard let statsCode = statusCode else { return }
            if statsCode >= 200 && statsCode <= 299 {
                AlertManager.shared.showAlertTitle(title: "Success!!" ,message: "Transaction has been completed.", buttonsArray: ["OK"]) { (buttonIndex : Int) in
                    switch buttonIndex {
                    case 0 :
                        //OK clicked
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    default:
                        self.navigationController?.popToRootViewController(animated: true)
                        break
                    }
                }
            } else {
                if statsCode == 404{
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
extension TMAnonymousVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if newLength > 11 { return false }
        
        let compSepByCharInSet  = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
        let strFiltered         = compSepByCharInSet.joined(separator: "")
        
        if string == strFiltered {
            let nsStr           = textField.text as NSString? ?? ""
            var str             = nsStr.replacingCharacters(in: range, with: string).replacingOccurrences(of: ".", with: "")
            str                 = str.replacingOccurrences(of: "$", with: "")
            let range: NSRange  = (str as NSString).range(of: "^0*", options: .regularExpression)
            str                 = (str as NSString).replacingCharacters(in: range, with: "")
            
            if str.count == 0 {
                str             = "$0.00"
            } else if str.count == 1 {
                str             = "$0.0" + str
            }
            else if str.count == 2 {
                str             = "$0." + str
            }else{
                str.insert(".", at: str.index(str.endIndex, offsetBy: -2))
            }
            txtAmount.text      = str.contains("$") ? str : "$" + str
        }
        return false
    }
}
