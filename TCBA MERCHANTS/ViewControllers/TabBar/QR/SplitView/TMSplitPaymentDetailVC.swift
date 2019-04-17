//
//  TMSplitPaymentDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 28/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import Alamofire

class TMSplitPaymentDetailVC: UIViewController {
    
    //MARK: Modals Object
    var posData         : PostCreatePOSModel!
    var paymentOptionsBackUp  : [PostCreatePOSPaymentOption]!
    //Constraints
    @IBOutlet weak var consHeightTbl: NSLayoutConstraint!
    @IBOutlet weak var consTopV: NSLayoutConstraint!
    @IBOutlet weak var consLblTapOnCardHeight: NSLayoutConstraint!
    
    //TableView
    @IBOutlet weak var tblVpayment: UITableView!
    //ScrollVIew
    @IBOutlet weak var scrV: UIScrollView!
    // Variables
    var arrTV           = [Dictionary<String,String>]()
    var arrCreditCards  = [PostCreatePOSPaymentOption]()
    var strCCToken      = ""
    var strPinCode      = ""
    
    // Enum Object
    var typeView         : viewType!
    var typeTable        : tableType!
    var typeMethod       : methodType!
    
    
    // UIImageView
    @IBOutlet weak var imgVUser: RoundedImage!
    
    // UILabels
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMemberId: UILabel!
    
    @IBOutlet weak var lblTransaction: UILabel!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblStoreID: UILabel!
    @IBOutlet weak var lblPOSID: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblBalanceOutStanding: UILabel!
    @IBOutlet weak var lblOutStandingValue: UILabel!
    @IBOutlet weak var lblTapOnCard: CustomLabel!
    
    //UIView
    @IBOutlet weak var viewTable: UIView!
    
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //<------Update tableView for types
        CompletionHandler.shared.litsenerEvent(.svReloadTbl) { (tType) in
            if let type = tType as? tableType {
                self.typeView = type == .card ? .home : .mixPayment
                self.reloadTableView(withTblType: type == .card ? .card : .mix)
                self.scrV.isScrollEnabled = true
            }
        }
        
        //<-----Hide TableView container if not Mix payment or credidit card selected on master view controller
        CompletionHandler.shared.litsenerEvent(.hideTableContainerPayment) { (tBool) in
            if self.viewTable.isHidden == false{
                self.viewTable.animateHideShow()
                self.scrV.scrollToTop()
                self.scrV.isScrollEnabled = false
            }
        }
        
        if typeTable == nil {
            typeTable = .mix
        }
        
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        
        /*   navigationItem.leftBarButtonItem    = UIBarButtonItem(image: UIImage(named: "back_button"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction)) */
        if Thread.isMainThread {
            self.lblUserName.font           = UIFont.applyOpenSansSemiBold(fontSize: 12.0, isAspectRasio: false)
            self.lblMemberId.font           = UIFont.applyOpenSansRegular(fontSize: 11.0, isAspectRasio: false)
            
            self.lblTransaction.font        = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
            self.lblCashBack.font           = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
            self.lblDateTime.font           = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            self.lblCity.font               = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            
            self.lblStoreID.font            = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            self.lblPOSID.font              = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            self.lblAmount.font             = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            self.lblBalanceOutStanding.font = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            self.lblOutStandingValue.font   = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
        }else{
            DispatchQueue.main.async {
                self.lblUserName.font           = UIFont.applyOpenSansSemiBold(fontSize: 12.0, isAspectRasio: false)
                self.lblMemberId.font           = UIFont.applyOpenSansRegular(fontSize: 11.0, isAspectRasio: false)
                
                self.lblTransaction.font        = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
                self.lblCashBack.font           = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
                self.lblDateTime.font           = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
                self.lblCity.font               = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
                
                self.lblStoreID.font            = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
                self.lblPOSID.font              = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
                self.lblAmount.font             = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
                self.lblBalanceOutStanding.font = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
                self.lblOutStandingValue.font   = UIFont.applyOpenSansSemiBold(fontSize: 12.0)
            }
        }
        
        
        lblUserName.text                    = posData.memberFullName!
        lblMemberId.text                    = "Member ID: \(posData.memberID ?? 0)"
        guard let urlProfile = URL.init(string: posData.profileImageURL ?? "") else {return}
        imgVUser.setImageWithDownload(urlProfile, withIndicator: true)
        
        //Top View
        lblDateTime.text                    = Date().currentDate()
        lblCity.text                        = posData.storeCity
        lblStoreID.text                     = "Store ID: \(posData.storeID ?? 0)"
        lblPOSID.text                       = "POS ID:\(posData.posid ?? 0)"
        lblAmount.text                      = "Amount: $\(posData.totalPurchaseAmount ?? 0.00)"
        lblOutStandingValue.text            = "$\(posData.balanceRemaining ?? 0.00)"
        
        
        // Array for TableView in mix payments
        
        arrTV = [
            [   "image"            : "cash_icon",
                "title"            : "Cash or EFTPOS",
                "balance"          : "",
                "selectedAmount"   : "",
                "method"           : "CashOrEFTPOS",
                "posPaymentID"     : ""],
            
            [   "image"            : "loyality_icon",
                "title"            : "Loyalty Credits",
                "balance"          : "\(posData.availableLoyaltyCash ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "LoyaltyCash",
                "posPaymentID"     : ""],
            
            [   "image"            : "wallet_icon",
                "title"            : "Wallet Funds",
                "balance"          : "\(posData.walletBalance ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "Wallet",
                "posPaymentID"     : ""],
            
            [   "image"            : "prizefundtrophy",
                "title"            : "Prize Funds",
                "balance"          : "\(posData.availablePrizeCash ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "PrizeWallet",
                "posPaymentID"     : ""],
            
            [   "image"            : "card_icon",
                "title"            : "Saved Credit Cards",
                "balance"          : "",
                "selectedAmount"   : "",
                "method"           : "TokenisedCreditCard",
                "posPaymentID"     : ""]]
        
        
        // Array of Credit Cards
        if let paymentOptions = posData.paymentOptions {
            paymentOptionsBackUp = paymentOptions
            for item in paymentOptions {
                if item.type == "TokenisedCreditCard" {
                    arrCreditCards.append(item)
                }
            }
        }
        //        // Top View Height
        consTopV.constant       = GConstant.Screen.Height * 0.3
        // ColectionView Layout setup
        consHeightTbl.constant  = GConstant.Screen.Height * 0.65
        view.setNeedsLayout()
    }
    
    //MARK: - Custom Methods
    func backToQR() {
        //This method will get back to you transaction view Controller
        
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = Tabbar.coustomTabBar(withIndex: 2)
    }
    
    func resetPayments() {
        AlertManager.shared.showAlertTitle(title: "", message: "This action will reset this payment method. Continue?", buttonsArray: ["Cancel","Yes, reset"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //Cancel clicked
                break
            case 1:
                self.callPostRemoveAllPOSPayments()
                break
            default:
                break
            }
        }
    }
    
    func reloadTableView(withTblType type: tableType){
        typeTable = type
        UIView.transition(with: tblVpayment, duration: 0.5, options:  .transitionCrossDissolve, animations: {
            self.tblVpayment.reloadData()
        }, completion: { (bool) in
            UIView.transition(with: self.viewTable, duration: 0.5, options: [.showHideTransitionViews, .transitionCrossDissolve], animations: {
                if self.viewTable.isHidden == true{
                    self.viewTable.isHidden = false
                }
            }, completion: nil)
        })
    }
    
    func showPin(withMethod method: methodType, currentBalance: Double? = 0.00,transactionAmount: Double?, completion   : @escaping (_ pinCode : String) -> Void){
        let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.PinView) as! TMPinViewController
        obj.method              = method.rawValue
        obj.balance             = String(format: "%.2f", currentBalance!)
        obj.amount              = String(format: "%.2f", transactionAmount ?? 0.00)
        obj.completionHandler   = { (pinCode) in
            if pinCode != "" {
                completion(pinCode)
            }
        }
        obj.modalPresentationStyle  = .overCurrentContext
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    
    func showPopUp(withMethod method: methodType,transactionAmount: Double?,cardNumber: String? = "",txtUserIntrection: Bool = false, completion   : @escaping (_ amount : String) -> Void){
        let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.PopUP) as! TMPopUPVC
        obj.method              = method.rawValue
        obj.txtUserIntrection   = txtUserIntrection
        obj.typePopUp           = method == .TokenisedCreditCard ? .creditCard : .other
        obj.strCardNumber       = cardNumber!
        obj.transactionAmount   = String(format: "%.2f", transactionAmount ?? 0.00)
        obj.completionHandler   = { (amount) in
            if amount != "" {
                let strAmount = amount.replacingOccurrences(of: "$", with: "")
                completion(strAmount)
            }
        }
        obj.modalPresentationStyle  = .overCurrentContext
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    
    func showPaymentSuccessPopUp(withPosData pData: PostCreatePOSModel, completion   : @escaping (_ amount : String) -> Void){
        let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.PaymentSuccessPopUp) as! TMPaySuccessPopUpVC
        obj.posData             = pData
        obj.completionHandler   = { (True) in
            completion(True)
        }
        obj.modalPresentationStyle  = .overCurrentContext
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    
    //MARK: UIButton action methods
    @IBAction func btnCancelAction(_ sender: UIButton) {
        if let payments = posData.payments {
            if payments.count > 0{
                resetPayments()
            }
        }
    }
    
    @IBAction func btnFinishAction(_ sender: UIButton) {
        if let payments = self.posData.payments{
            var execute = 1
            if payments.count == 1 && payments[0].type == "CashOrEFTPOS" {
                self.callPostCreateTransaction(payMethodType: .Mix, withPin: "", isExecute: execute)
            } else {
                showPin(withMethod: .Mix, transactionAmount: posData?.totalTransactionFees) { (pinCode) in
                    if let payments = self.posData.payments{
                        for item in payments{
                            if item.type == "TokenisedCreditCard"{
                                execute = 0
                                 break
                            }
                        }
                    }
                    self.strPinCode = pinCode
                    self.callPostCreateTransaction(payMethodType: .Mix, withPin: pinCode, isExecute: execute)
                }
            }
        }
    }
    
    
    //MARK: - Web Api's
    
    func callPostCreateTransactionWithFullPayment(payMethodType type:methodType, withPin pin: String = "", isExecute: Int = 1, withToken token: String = "") {
        /*
         =====================API CALL=====================
         APIName    : PostCreateTransactionWithFullPayment
         Url        : "/Payment/POS/PostCreateTransactionWithFullPayment"
         Method     : POST
         Parameters : {
         
         //Case: Wallet, CashOrEFTPOS, LoyaltyCash
         execute        : 0,-->For this case by default value of execute is 1
         memberPin      : 1234,
         paymentType    : Wallet,
         posID          : 5610
         
         //Case: Prize Wallet
         execute        : 0,-->For this case by default value of execute is 1
         memberPin      : 1234,
         paymentType    : PrizeWallet,
         posID          : 5610
         accountNumber  : Method PrizeWallet from Payment Options in POSData
         
         //Case: TokenisedCreditCard
         execute        : 0,-->For this case first time 0 and 2nd time 1
         memberPin      : 1234,
         paymentType    : TokenisedCreditCard,
         posID          : 5610
         creditCardToken: token
         }
         ===================================================
         */
        
        let request             = RequestModal.mCreatePOS()
        request.memberPin       = pin
        request.paymentType     = type.rawValue
        request.posID           = posData.posid
        request.execute         = isExecute
        
        if type == .PrizeWallet {
            if let paymentOptions = posData.paymentOptions {
                for item in paymentOptions {
                    if item.type == type.rawValue {
                        request.accountNumber = item.accountNumber
                    }
                }
            }
        } else if type == .TokenisedCreditCard {
            request.creditCardToken = token
        }
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostCreateTransactionWithFullPayment, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("statusCode = 200")
                guard data != nil else{return}
                if let pData = try? PostCreatePOSModel.decode(_data: data!) {
                    self.posData = pData
                    
                    if isExecute == 0 {
                        let message = String(format:"Total funds taken from source: %.2f\n Service Fee: %.2f\n Transaction Fee: %.2f\n Total transferred to recipient: %.2f\n\n Do you want to continue?" , pData.totalAmountPaidByMember!,pData.totalServiceFees!,pData.totalTransactionFees!,pData.totalPurchaseAmount!)
                        
                        AlertManager.shared.showAlertTitle(title: "", message: message, buttonsArray: ["CANCEL","CONTINUE"]) { (buttonIndex : Int) in
                            switch buttonIndex {
                            case 0 :
                                //CANCEL clicked
                                break
                            case 1:
                                //CONTINUE clicked
                                self.callPostCreateTransactionWithFullPayment(payMethodType: .TokenisedCreditCard, withPin: self.strPinCode, isExecute: 1, withToken: self.strCCToken)
                                break
                            default:
                                break
                            }
                        }
                    }else{
                        if pData.paidInFull == true {
                            self.showPaymentSuccessPopUp(withPosData: pData, completion: { (_) in
                                self.backToQR()
                            })
                        }
                    }
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }else{
                if let data = data{
                    guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String]) as [String : String]??) else {
                        let str = String(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return }
                    
                    if statusCode == 400 {
                        print(json as Any)
                        if json?["message"] == "PIN Locked." {
                            AlertManager.shared.showAlertTitle(title: "Wallet Locked", message: "Incorrect PIN entered too many times, Your wallet is now locked. please pay cash or EFTPOS to complete this transaction", buttonsArray: ["OK"]) { (buttonIndex : Int) in
                                switch buttonIndex {
                                case 0 :
                                    //OK clicked
                                    self.callPostRemoveAllPOSPayments()
                                    break
                                default:
                                    
                                    break
                                }
                            }
                        } else if json?["message"]?.contains("Unknown biller code") ?? false || json?["message"]?.contains("Customer Reference Number is invalid") ?? false {
                            
                            AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] ?? GConstant.Message.kSomthingWrongMessage, buttonsArray: ["OK"]) { (buttonIndex : Int) in
                                switch buttonIndex {
                                case 0 :
                                    //OK clicked
                                    self.backToQR()
                                    break
                                default:
                                    self.backToQR()
                                    break
                                }
                            }
                        } else {
                            AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] ?? GConstant.Message.kSomthingWrongMessage)
                        }
                    }
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
    
    func callPostAddPOSPayment(amount:String,payMethodType type:methodType, withToken token: String = "") {
        /*
         =====================API CALL=====================
         APIName    : PostAddPOSPayment
         Url        : "/Payment/POS/PostAddPOSPayment"
         Method     : POST
         Parameters : {
         POSID : 5623,
         accountNumber : 6279059720828018,
         amount : "0.49",
         paymentType : Wallet
         }
         ===================================================
         */
        let request             = RequestModal.mCreatePOS()
        request.paymentType     = type.rawValue
        request.posID           = posData.posid
        request.amount          = amount
        
        if type == .PrizeWallet || type == .Wallet {
            if let paymentOptions = posData.paymentOptions {
                for item in paymentOptions {
                    if item.type == type.rawValue {
                        request.accountNumber = item.accountNumber
                    }
                }
            }
        } else if type == .TokenisedCreditCard {
            request.creditCardToken = token
        }
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostAddPOSPayment, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("statusCode = 200")
                guard data != nil else{return}
                if let pData = try? PostCreatePOSModel.decode(_data: data!) {
                    self.posData    = pData
                    self.lblOutStandingValue.text  = "$\(self.posData.balanceRemaining ?? 0.00)"
                    if let payments = self.posData.payments {
                        if payments.count > 0 {
                            CompletionHandler.shared.triggerEvent(.checkPayment, passData: true)
                        }
                        for item in payments {
                            if item.type == type.rawValue {
                                for index in self.arrTV.indices{
                                    if self.arrTV[index]["method"] == type.rawValue{
                                        self.arrTV[index]["selectedAmount"] = "\(item.amountPaidByMember ?? 0.00)"
                                        self.arrTV[index]["posPaymentID"]   = "\(item.posPaymentID ?? 0)"
                                    }
                                }
                            }
                        }
                    }
                    self.reloadTableView(withTblType: .mix)
                    if let payment = pData.payments?.count {
                        if payment > 0{
                            self.btnCancel.isHidden = false
                        }
                    }
                    if pData.balanceRemaining == 0 {
                        self.btnFinish.isHidden = false
                    }
                } else {
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
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
    
    
    func callPostCreateTransaction(payMethodType type:methodType, withPin pin: String = "", isExecute: Int = 1) {
        /*
         =====================API CALL=====================
         APIName    : PostCreateTransaction
         Url        : "/Payment/POS/PostCreateTransaction"
         Method     : POST
         Parameters : { }
         ===================================================
         */
        let request             = RequestModal.mCreatePOS()
        request.memberPin       = pin
        request.posID           = posData.posid
        request.execute         = isExecute
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostCreateTransaction, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("statusCode = 200")
                guard data != nil else{return}
                if let pData = try? PostCreatePOSModel.decode(_data: data!) {
                    self.posData = pData
                    
                    if isExecute == 0 {
                        let message = String(format:"Total funds taken from source: %.2f\n Service Fee: %.2f\n Transaction Fee: %.2f\n Total transferred to recipient: %.2f\n\n Do you want to continue?" , pData.totalAmountPaidByMember!,pData.totalServiceFees!,pData.totalTransactionFees!,pData.totalPurchaseAmount!)
                        
                        AlertManager.shared.showAlertTitle(title: "", message: message, buttonsArray: ["CANCEL","CONTINUE"]) { (buttonIndex : Int) in
                            switch buttonIndex {
                            case 0 :
                                //CANCEL clicked
                                break
                            case 1:
                                //CONTINUE clicked
                                self.callPostCreateTransaction(payMethodType: .Mix, withPin: self.strPinCode)
                                break
                            default:
                                break
                            }
                        }
                    } else {
                        if pData.paidInFull == true {
                            self.showPaymentSuccessPopUp(withPosData: pData, completion: { (_) in
                                self.backToQR()
                            })
                        }
                    }
                } else {
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
                
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
                        if (json?["message"] as? String) == "PIN Locked." {
                            AlertManager.shared.showAlertTitle(title: "Wallet Locked", message: "Incorrect PIN entered too many times, Your wallet is now locked. please pay cash or EFTPOS to complete this transaction", buttonsArray: ["Close"]) { (buttonIndex : Int) in
                                switch buttonIndex {
                                case 0 :
                                    self.callPostRemoveAllPOSPayments()
                                    break
                                default:
                                    break
                                }
                            }
                        }  else if (json?["message"] as? String)?.contains("Unknown biller code") ?? false || (json?["message"] as? String)?.contains("Customer Reference Number is invalid") ?? false {
                            
                            AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage, buttonsArray: ["OK"]) { (buttonIndex : Int) in
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
                            AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage )
                        }
                    }else{
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                    }
                }
            }
        }
    }
    
    func callPostRemoveAllPOSPayments() {
        /*
         =====================API CALL=====================
         APIName    : PostRemoveAllPOSPayments
         Url        : "/Payment/POS/PostRemoveAllPOSPayments"
         Method     : POST
         Parameters : { posID   : 123 }
         ===================================================
         */
        guard let id = posData.posid else { return }
        let url = GAPIConstant.Url.PostRemoveAllPOSPayments + "?posID=\(id)"
        
        ApiManager.shared.POSTWithBearerAuth(strURL: url, parameter: [:], encording: URLEncoding.default) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard data != nil else{return}
                let str = String(data: data!, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                AlertManager.shared.showAlertTitle(title: "" ,message:str)
                for index in self.arrTV.indices{
                    self.arrTV[index]["selectedAmount"] = ""
                    self.arrTV[index]["posPaymentID"]   = ""
                }
                self.lblOutStandingValue.text   = "\(self.posData.totalPurchaseAmount ?? 0.00)"
                self.btnFinish.isHidden         = true
                self.posData.payments?.removeAll()
                if self.posData.paymentOptions?.count == 0 {
                    self.posData.paymentOptions = self.paymentOptionsBackUp
                }
                self.posData.balanceRemaining   = self.posData.totalPurchaseAmount
                self.viewTable.animateHideShow()
                self.btnFinish.isHidden         = true
                self.btnCancel.isHidden         = true
                self.scrV.scrollToTop() 
                self.scrV.isScrollEnabled       = false
                
                CompletionHandler.shared.triggerEvent(.checkPayment, passData: false)
                
                
            } else {
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

extension TMSplitPaymentDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard posData != nil else { return 0}
        if typeTable == .card {
            return arrCreditCards.count
        } else {
            return arrTV.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if typeTable == .card {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTVCell") as! TMStorePaymentTVCell
            DispatchQueue.main.async {
                cell.lblTitle.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 14.0), labelColor: GConstant.AppColor.textLight)
                cell.lblTitle.text          = self.typeView == .mixPayment ? "Saved Credit Cards(MixPayments)" : "Saved Credit Cards"
                cell.imgVTV.image           = UIImage(named: "card_icon")
                cell.lblAmtPaid.isHidden    = true
                cell.lblBal.isHidden        = true
                cell.lblAvailable.isHidden  = true
                cell.vBlueLine.isHidden     = false
                cell.contentView.alpha      = 1.0
            } 
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if typeTable == .card {
            consLblTapOnCardHeight.constant = 30.0
            lblTapOnCard.setNeedsUpdateConstraints()
            lblTapOnCard.isHidden           = false
            return 50 * GConstant.Screen.HeightAspectRatio
        } else {
            consLblTapOnCardHeight.constant = 0.0
            lblTapOnCard.setNeedsUpdateConstraints()
            lblTapOnCard.isHidden           = true
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if typeTable == .card {
            if arrCreditCards[indexPath.row].isPremium ?? false {
                return 80 * GConstant.Screen.HeightAspectRatio
            }
        }
        return 58 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typeTable == .mix {// Table for Mix payment
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTVCell") as! TMStorePaymentTVCell
            
            DispatchQueue.main.async {
                cell.lblTitle.font          = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
                cell.lblBal.font            = UIFont.applyOpenSansRegular(fontSize: 14.0)
                cell.lblAvailable.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
                cell.lblAmtPaid.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 14.0), borderColor: GConstant.AppColor.textDark, backgroundColor: .white, borderWidth: 1.0)
                
                cell.imgVTV.image           = UIImage(named: self.arrTV[indexPath.item]["image"]!)
                cell.lblTitle.text          = self.arrTV[indexPath.item]["title"]
                cell.lblBal.text            = "$" + self.arrTV[indexPath.item]["balance"]!
                
                cell.contentView.alpha      = GFunction.shared.checkPaymentOptions(withPosData: self.posData, Method: self.arrTV[indexPath.item]["method"]!, withViewType: .mixPayment) ? 1.0 : 0.5
                
                if self.arrTV[indexPath.item]["method"] == "TokenisedCreditCard" || self.arrTV[indexPath.item]["method"] == "CashOrEFTPOS" {
                    cell.lblBal.isHidden        = true
                    cell.lblAvailable.isHidden  = true
                }else{
                    cell.lblBal.isHidden        = false
                    cell.lblAvailable.isHidden  = false
                }
                
                cell.vBlueLine.isHidden     = true
                cell.lblAmtPaid.isHidden    = true
                cell.consLblWidth.constant  = 0.0
                
            }
            guard self.posData != nil else { return cell }
            if let payments = self.posData.payments {
                if payments.count > 0{
                    for item in payments{
                        DispatchQueue.main.async {
                            if item.type == self.arrTV[indexPath.row]["method"] {
                                cell.vBlueLine.isHidden     = false
                                cell.lblAmtPaid.isHidden    = false
                                cell.consLblWidth.constant  = GConstant.Screen.Width * 0.18
                                cell.lblAmtPaid.text        = self.arrTV[indexPath.row]["selectedAmount"]
                            }
                        }
                    }
                }
            }
            
            cell.layoutIfNeeded()
            return cell
        } else { // Table for Card list
            if arrCreditCards[indexPath.row].isPremium ?? false {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumCardCell") as! TMPremiumCardCell
                DispatchQueue.main.async {
                    cell.lblCardNo.font         = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
                    cell.lblPremium.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 14.0), cornerRadius: 4.0*GConstant.Screen.HeightAspectRatio)
                }
                if let name = arrCreditCards[indexPath.row].name {
                    cell.lblCardNo.text = name
                    if name.contains("MASTERCARD") {
                        cell.imgVIcon.image = UIImage(named: "master")
                    }else if name.contains("VISA"){
                        cell.imgVIcon.image = UIImage(named: "visa")
                    }else if name.contains("AMEX"){
                        cell.imgVIcon.image = UIImage(named: "amex")
                    }else if name.contains("DINER"){
                        cell.imgVIcon.image = UIImage(named: "diner")
                    }
                }
                cell.setNeedsDisplay()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CardTVCell") as! TMCardTVCell
                DispatchQueue.main.async {
                    cell.lblCardNo.font = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
                }
                
                if let name = arrCreditCards[indexPath.row].name {
                    cell.lblCardNo.text = name
                    if name.contains("MASTERCARD") {
                        cell.imgVIcon.image = UIImage(named: "master")
                    }else if name.contains("VISA"){
                        cell.imgVIcon.image = UIImage(named: "visa")
                    }else if name.contains("AMEX"){
                        cell.imgVIcon.image = UIImage(named: "amex")
                    }else if name.contains("DINER"){
                        cell.imgVIcon.image = UIImage(named: "diner")
                    }
                }
                cell.setNeedsDisplay()
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeTable == .mix {
            if arrTV[indexPath.row]["selectedAmount"] != "" {
                resetPayments()
                return
            }
            
            if !GFunction.shared.checkPaymentOptions(withPosData: self.posData, Method:  arrTV[indexPath.row]["method"]!, withViewType: .mixPayment) {
                return
            }
            
            if indexPath.row == 0 {
                //<===CashOrEFTPOS===>
                showPopUp(withMethod: .CashOrEFTPOS, transactionAmount: posData.balanceRemaining, txtUserIntrection: true) { (amount) in
                    self.callPostAddPOSPayment(amount: amount, payMethodType: .CashOrEFTPOS)
                }
            } else if indexPath.row == 1 {
                //<===LoyaltyCash===>
                showPopUp(withMethod: .LoyaltyCash, transactionAmount: posData.balanceRemaining, txtUserIntrection: true) { (amount) in
                    self.callPostAddPOSPayment(amount: amount, payMethodType: .LoyaltyCash)
                }
            } else if indexPath.row == 2 {
                //<===WalletFunds===>
                showPopUp(withMethod: .Wallet, transactionAmount: posData.balanceRemaining, txtUserIntrection: true) { (amount) in
                    self.callPostAddPOSPayment(amount: amount, payMethodType: .Wallet)
                }
            } else if indexPath.row == 3 {
                //<===PrizeFunds===>
                showPopUp(withMethod: .PrizeWallet, transactionAmount: posData.balanceRemaining, txtUserIntrection: true) { (amount) in
                    self.callPostAddPOSPayment(amount: amount, payMethodType: .PrizeWallet)
                }
            } else if indexPath.row == 4 {
                //<===TokenisedCreditCard===>
                if arrCreditCards.count == 0{
                    AlertManager.shared.showAlertTitle(title: "", message: "Please attach a credit card to your wallet to use this feature.")
                }else{
                    reloadTableView(withTblType: .card)
                }
            }
        }else{
            if typeView == .mixPayment {
                showPopUp(withMethod: .TokenisedCreditCard, transactionAmount: posData.balanceRemaining, cardNumber: arrCreditCards[indexPath.row].name, txtUserIntrection: true) { (amount) in
                    self.callPostAddPOSPayment(amount: amount, payMethodType: .TokenisedCreditCard, withToken: self.arrCreditCards[indexPath.row].token!)
                }
            }else{
                showPin(withMethod: .TokenisedCreditCard, transactionAmount: posData.balanceRemaining ?? 0.00, completion: {(pinCode) in
                    self.strCCToken = self.arrCreditCards[indexPath.row].token ?? ""
                    self.strPinCode = pinCode
                    self.callPostCreateTransactionWithFullPayment(payMethodType: .TokenisedCreditCard, withPin: self.strPinCode, isExecute: 0, withToken: self.strCCToken)
                })
            }
        }
    }
}
