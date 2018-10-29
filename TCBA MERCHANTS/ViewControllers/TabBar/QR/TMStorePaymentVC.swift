//
//  TMStorePaymentVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 17/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import Alamofire
//MARK: Structurs
struct PaymentMethod: Codable {
    var image, title, method: String?
    var balance, selectedAmount : Double?
    var posPaymentID: Int?
}

//MARK: Enums
enum viewType: uint {
    case home
    case mixPayment
}
enum tableType: uint {
    case mix
    case card
}
enum methodType: String {
    case CashOrEFTPOS           = "CashOrEFTPOS"
    case Wallet                 = "Wallet"
    case TokenisedCreditCard    = "TokenisedCreditCard"
    case PrizeWallet            = "PrizeWallet"
    case LoyaltyCash            = "LoyaltyCash"
    case Mix                    = "Mix Payments"
}

class TMStorePaymentVC: UIViewController {
    
    //MARK: Modals Object
    var posData         : PostCreatePOSModel!
    var paymentOptionsBackUp  : [PostCreatePOSPaymentOption]!
    
    
    //MARK: Outlets & Variables
    //Constraints
    @IBOutlet weak var consCvHeight: NSLayoutConstraint!
    @IBOutlet weak var consTopView: NSLayoutConstraint!
    
    // Variables
    var arrCV           = [PaymentMethod]()
    var arrTV           = [PaymentMethod]()
    var arrCreditCards  = [PostCreatePOSPaymentOption]()
    var strCCToken      = ""
    var strPinCode      = ""
    
    
    // Enum Object
    var typeView         : viewType!
    var typeTable        : tableType!
    var typeMethod       : methodType!
    
    // UIVIew
    @IBOutlet weak var viewCollection: UIView!
    @IBOutlet weak var viewTable: UIView!
    
    
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
    
    // CollectionView
    @IBOutlet weak var colVPayment: UICollectionView!
    // TableView
    @IBOutlet weak var tblVpayment: UITableView!
    //UIButton
    @IBOutlet weak var btnFinish: UIButton!
    
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
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title           = "Cash Back Purchase"
        navigationItem.leftBarButtonItem    = UIBarButtonItem(image: UIImage(named: "back_button"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonAction))
        
        lblUserName.font                    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblMemberId.font                    = UIFont.applyOpenSansRegular(fontSize: 15.0)
        guard posData != nil else { return }
        lblUserName.text                    = posData.memberFullName ?? "TCBA"
        lblMemberId.text                    = "Member Id: \(posData.memberID ?? 0)"
        guard let urlProfile = URL.init(string: posData.profileImageURL ?? "") else {return}
        imgVUser.setImageWithDownload(urlProfile, withIndicator: true)
        
        //Top View
        lblDateTime.text                    = Date().currentDate()
        lblCity.text                        = posData.storeCity
        lblStoreID.text                     = "Store ID: \(posData.storeID ?? 0)"
        lblPOSID.text                       = "POS ID:\(posData.posid ?? 0)"
        lblAmount.text                      = "Amount: $\(posData.totalPurchaseAmount ?? 0.00)"
        lblOutStandingValue.text            = "$\(posData.balanceRemaining ?? 0.00)"
        
        // Array For Collecion View
        arrCV = [PaymentMethod.init(image: "cash_icon", title: "Cash or EFTPOS", method: "CashOrEFTPOS", balance: 0.00, selectedAmount: 0.00, posPaymentID: 0),
                 PaymentMethod.init(image: "wallet_icon", title: "Wallet Funds", method: "Wallet", balance: posData.walletBalance ?? 0.00, selectedAmount: 0.00, posPaymentID: 0),
                 PaymentMethod.init(image: "card_icon", title: "Saved Credit Cards", method: "TokenisedCreditCard", balance: 0.00, selectedAmount: 0.00, posPaymentID: 0),
                 PaymentMethod.init(image: "prizefundtrophy", title: "Prize Funds", method: "PrizeWallet", balance: posData.availablePrizeCash ?? 0.00, selectedAmount: 0.00, posPaymentID: 0),
                 PaymentMethod.init(image: "loyality_icon", title: "Loyalty Credits", method: "LoyaltyCash", balance: posData.availableLoyaltyCash ?? 0.00, selectedAmount: 0.00, posPaymentID: 0),
                 PaymentMethod.init(image: "mixpayment", title: "Mixed Payment", method: "", balance: 0.00, selectedAmount: 0.00, posPaymentID: 0)]
        
        // Array for TableView in mix payments
        arrTV = [PaymentMethod.init(image: "cash_icon", title: "Cash or EFTPOS", method: "CashOrEFTPOS", balance: 0.00, selectedAmount: 0.00, posPaymentID: 0),
            PaymentMethod.init(image: "loyality_icon", title: "Loyalty Credits", method: "LoyaltyCash", balance: posData.availableLoyaltyCash ?? 0.00, selectedAmount: 0.00, posPaymentID: 0),
            PaymentMethod.init(image: "wallet_icon", title: "Wallet Funds", method: "Wallet", balance: posData.walletBalance ?? 0.00, selectedAmount: 0.00, posPaymentID: 0),
            PaymentMethod.init(image: "prizefundtrophy", title: "Prize Funds", method: "PrizeWallet", balance: posData.availablePrizeCash ?? 0.00, selectedAmount: 0.00, posPaymentID: 0),
            PaymentMethod.init(image: "card_icon", title: "Saved Credit Cards", method: "TokenisedCreditCard", balance: 0.00, selectedAmount: 0.00, posPaymentID: 0)]
        
        // Array of Credit Cards
        if let paymentOptions = posData.paymentOptions {
            paymentOptionsBackUp = paymentOptions
            for item in paymentOptions {
                if item.type == "TokenisedCreditCard" {
                    arrCreditCards.append(item)
                }
            }
        }
        // Top View Height
        consTopView.constant    = GConstant.Screen.Height * 0.42
        // ColectionView Layout setup
        consCvHeight.constant   = GConstant.Screen.Height * 0.4
        view.setNeedsLayout()
    }
    
    //MARK: - BarButton Action Methods
    @objc func backButtonAction(sender: UIBarButtonItem){
        cancelTransaction()
    }
    
    //MARK: - UIButton Action Metods
    @IBAction func btnCVCancelAction(_ sender: UIButton) {
        cancelTransaction()
    }
    
    @IBAction func btnTVCancelAction(_ sender: UIButton) {
        if let payments = posData.payments {
            if payments.count > 0{
                resetPayments()
            }else{
                viewTable.animateHideShow()
            }
        } else {
            viewTable.animateHideShow()
        }
    }
    
    @IBAction func btnFinishAction(_ sender: UIButton) {
        showPin(withMethod: .Mix, transactionAmount: posData.totalTransactionFees) { (pinCode) in
            var execute = 1
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
    //MARK: - Custom Methods
    func cancelTransaction() {
        AlertManager.shared.showAlertTitle(title: "Cancel Transaction?", message: "Are you sure want to cancel this transaction?", buttonsArray: ["NO","YES"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                self.navigationController?.popToRootViewController(animated: true)
                break
            default:
                break
            }
        }
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
        tblVpayment.reloadData()
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
        self.navigationController?.present(obj, animated: true, completion: nil)
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
        self.navigationController?.present(obj, animated: true, completion: nil)
    }
    
    //MARK: Web Api's
    
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
                        if pData.paidInFull == true{
                            AlertManager.shared.showAlertTitle(title: "Success", message: "Payment successful.", buttonsArray: ["OK"]) { (buttonIndex : Int) in
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
                        }
                    }
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {
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
                                    self.navigationController?.popToRootViewController(animated: true)
                                    break
                                default:
                                    self.navigationController?.popToRootViewController(animated: true)
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
                        for item in payments {
                            if item.type == type.rawValue {
                                for index in self.arrTV.indices{
                                    if self.arrTV[index].method == type.rawValue{
                                        self.arrTV[index].selectedAmount    = item.amountPaidByMember ?? 0.00
                                        self.arrTV[index].posPaymentID      = item.posPaymentID ?? 0
                                    }
                                }
                            }
                        }
                    }
                    self.reloadTableView(withTblType: .mix)
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
                    }else{
                        if pData.paidInFull == true{
                            AlertManager.shared.showAlertTitle(title: "Success", message: "Payment successful.", buttonsArray: ["OK"]) { (buttonIndex : Int) in
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
                        }
                    }
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
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
                    self.arrTV[index].selectedAmount = 0.00
                    self.arrTV[index].posPaymentID   = 0
                }
                self.lblOutStandingValue.text   = "\(self.posData.totalPurchaseAmount ?? 0.00)"
                self.btnFinish.isHidden         = true
                self.posData.payments?.removeAll()
                if self.posData.paymentOptions?.count == 0 {
                    self.posData.paymentOptions = self.paymentOptionsBackUp
                }
                self.posData.balanceRemaining   = self.posData.totalPurchaseAmount
                self.viewTable.animateHideShow()
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
extension TMStorePaymentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    //MARK: CollectionView Delegates & DataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = GConstant.Screen.Width
        return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard posData != nil else { return 0}
        return arrCV.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! TMStorePaymentCVCell
        
        cell.imgV.image         = UIImage(named: arrCV[indexPath.item].image!)
        cell.lblTitle.text      = arrCV[indexPath.item].title
        cell.lblTitle.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
        cell.contentView.alpha  = GFunction.shared.checkPaymentOptions(withPosData: posData, Method: arrCV[indexPath.item].method!, withViewType: .home) ? 1.0 : 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !GFunction.shared.checkPaymentOptions(withPosData: posData, Method: arrCV[indexPath.item].method!, withViewType: .home) {
            return
        }
        
        if indexPath.row == 0 {
            //<===CashOrEFTPOS===>
            showPopUp(withMethod: .CashOrEFTPOS, transactionAmount: posData.balanceRemaining, completion: {(amount) in
                self.callPostCreateTransactionWithFullPayment(payMethodType: .CashOrEFTPOS)
            })
        } else if indexPath.row == 1 {
            //<===Wallet===>
            if (posData.walletBalance?.isLess(than: posData.balanceRemaining!))!{
                AlertManager.shared.showAlertTitle(title: "Insufficent Funds", message: String(format: "You do not have enough funds.\nCurrent balance is $%.2f.\nPlease try another method or pay with Mixed Payment", posData.walletBalance!))
            }else{
                showPin(withMethod: .Wallet, currentBalance: posData.walletBalance, transactionAmount: posData.balanceRemaining) { (pinCode) in
                    self.callPostCreateTransactionWithFullPayment(payMethodType: .Wallet, withPin: pinCode)
                }
            }
        } else if indexPath.row == 2 {
            //<===TokenisedCreditCard===>
            if arrCreditCards.count == 0{
                AlertManager.shared.showAlertTitle(title: "", message: "Please attach a credit card to your wallet to use this feature.")
            }else{
                typeView = .home
                reloadTableView(withTblType: .card)
                viewTable.animateHideShow()
            }
        } else if indexPath.row == 3 {
            //<===PrizeWallet===>
            if (posData.walletBalance?.isLess(than: posData.balanceRemaining!))!{
                AlertManager.shared.showAlertTitle(title: "Insufficent Funds", message: String(format: "You do not have enough funds.\nCurrent balance is $%.2f.\nPlease try another method or pay with Mixed Payment", posData.availablePrizeCash!))
            }else{
                showPin(withMethod: .PrizeWallet, currentBalance: posData.walletBalance, transactionAmount: posData.balanceRemaining) { (pinCode) in
                    self.callPostCreateTransactionWithFullPayment(payMethodType: .PrizeWallet, withPin: pinCode)
                }
            }
        } else if indexPath.row == 4 {
            //<===LoyaltyCash===>
            if (posData.walletBalance?.isLess(than: posData.balanceRemaining!))!{
                AlertManager.shared.showAlertTitle(title: "Insufficent Funds", message: String(format: "You do not have enough funds.\nCurrent balance is $%.2f.\nPlease try another method or pay with Mixed Payment", posData.availableLoyaltyCash!))
            }else{
                showPin(withMethod: .LoyaltyCash, currentBalance: posData.walletBalance, transactionAmount: posData.balanceRemaining) { (pinCode) in
                    self.callPostCreateTransactionWithFullPayment(payMethodType: .LoyaltyCash, withPin: pinCode)
                }
            }
        } else if indexPath.row == 5 {
            //<===MixPayments===>
            reloadTableView(withTblType: .mix)
            viewTable.animateHideShow()
        }
    }
    
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
            cell.lblTitle.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight)
            cell.lblTitle.text          = "Saved Credit Cards"
            cell.imgVTV.image           = UIImage(named: "card_icon")
            cell.lblAmtPaid.isHidden    = true
            cell.lblBal.isHidden        = true
            cell.lblAvailable.isHidden  = true
            cell.vBlueLine.isHidden     = false
            cell.contentView.alpha      = 1.0
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if typeTable == .card {
            return 60 * GConstant.Screen.HeightAspectRatio
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if typeTable == .mix {// Table for Mix payment
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTVCell") as! TMStorePaymentTVCell
            
            cell.lblTitle.font          = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
            cell.lblBal.font            = UIFont.applyOpenSansRegular(fontSize: 15.0)
            cell.lblAvailable.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
            cell.lblAmtPaid.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 15.0), borderColor: GConstant.AppColor.textDark, backgroundColor: .white, borderWidth: 1.0)
            
            cell.imgVTV.image           = UIImage(named: arrTV[indexPath.item].image!)
            cell.lblTitle.text          = arrTV[indexPath.item].title
            cell.lblBal.text            = "$\(arrTV[indexPath.item].balance!)"
            
            cell.contentView.alpha      = GFunction.shared.checkPaymentOptions(withPosData: posData, Method: arrTV[indexPath.item].method!, withViewType: .mixPayment) ? 1.0 : 0.5
            
            if arrTV[indexPath.item].method == "TokenisedCreditCard" || arrTV[indexPath.item].method == "CashOrEFTPOS" {
                cell.lblBal.isHidden        = true
                cell.lblAvailable.isHidden  = true
            }else{
                cell.lblBal.isHidden        = false
                cell.lblAvailable.isHidden  = false
            }
            
            cell.vBlueLine.isHidden     = true
            cell.lblAmtPaid.isHidden    = true
            cell.consLblWidth.constant  = 0.0
            
            if let payments = posData.payments{
                if payments.count > 0{
                    for item in payments{
                        if item.type == arrTV[indexPath.row].method {
                            cell.vBlueLine.isHidden     = false
                            cell.lblAmtPaid.isHidden    = false
                            cell.consLblWidth.constant  = GConstant.Screen.Width * 0.18
                            cell.lblAmtPaid.text        = "\(arrTV[indexPath.row].selectedAmount ?? 0.00)"
                        }
                    }
                }
            }
            cell.layoutIfNeeded()
            return cell
        } else { // Table for Card list
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardTVCell") as! TMCardTVCell
            cell.lblCardNo.font          = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
            
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
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeTable == .mix {
            if arrTV[indexPath.row].selectedAmount != 0.00 {
                resetPayments()
                return
            }
            
            if !GFunction.shared.checkPaymentOptions(withPosData: posData, Method: arrTV[indexPath.item].method!, withViewType: .mixPayment) {
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
                if arrCreditCards.count == 0 {
                    AlertManager.shared.showAlertTitle(title: "", message: "Please attach a credit card to your wallet to use this feature.")
                }else{
                    typeView = .mixPayment
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
