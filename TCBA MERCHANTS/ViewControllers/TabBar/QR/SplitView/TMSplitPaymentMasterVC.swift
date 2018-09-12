//
//  TMSplitPaymentMasterVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 28/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import Alamofire

class TMSplitPaymentMasterVC: UIViewController {
    
    //MARK: Modals Object
    var posData                 : PostCreatePOSModel!
    var paymentOptionsBackUp    : [PostCreatePOSPaymentOption]!
    
    //Constraints
    @IBOutlet weak var consHeightCol: NSLayoutConstraint!
    
    // Variables
    var arrCV           = [Dictionary<String,String>]()
    var arrCreditCards  = [PostCreatePOSPaymentOption]()
    var strCCToken      = ""
    var strPinCode      = ""
    
    //CollectionView
    @IBOutlet weak var cvSplit: UICollectionView!
    
    //View
    @IBOutlet weak var ViewTop: UIView!
    
    var mixPayFlag = false
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(posData)
        CompletionHandler.shared.litsenerEvent(.checkPayment) { (bool) in
            if let flag = bool as? Bool {
                self.mixPayFlag = flag
                self.cvSplit.reloadData()
            }
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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard cvSplit != nil else { return }
        DispatchQueue.main.async {
            self.cvSplit.frame = CGRect(x: 0, y: self.ViewTop.bounds.maxY, width: self.view.bounds.width, height: GConstant.Screen.Height * 0.7)
            self.cvSplit.setNeedsDisplay()
            self.cvSplit.reloadData()
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
        self.navigationItem.title           = "Cash Back Purchase"
        
        navigationItem.leftBarButtonItem    = UIBarButtonItem(image: UIImage(named: "back_button"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        
        // ColectionView Layout setup
        consHeightCol.constant   = GConstant.Screen.Height * 0.7
        view.setNeedsLayout()
        
        guard posData != nil else { return }
        // Array For Collecion View
        arrCV = [
            [   "image"            : "cash_icon",
                "title"            : "Cash or EFTPOS",
                "balance"          : "",
                "selectedAmount"   : "",
                "method"           : "CashOrEFTPOS",
                "posPaymentID"     : ""],
            
            [   "image"            : "wallet_icon",
                "title"            : "Wallet Funds",
                "balance"          : "\(posData.walletBalance ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "Wallet",
                "posPaymentID"     : ""],
            
            [   "image"            : "card_icon",
                "title"            : "Saved Credit Cards",
                "balance"          : "",
                "selectedAmount"   : "",
                "method"           : "TokenisedCreditCard",
                "posPaymentID"     : ""],
            
            [   "image"            : "prizefundtrophy",
                "title"            : "Prize Funds",
                "balance"          : "\(posData.availablePrizeCash ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "PrizeWallet",
                "posPaymentID"     : ""],
            
            [   "image"            : "loyality_icon",
                "title"            : "Loyalty Credits",
                "balance"          : "\(posData.availableLoyaltyCash ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "LoyaltyCash",
                "posPaymentID"     : ""],
            
            [   "image"            : "mixpayment",
                "title"            : "Mixed Payment",
                "balance"          : "",
                "selectedAmount"   : "",
                "method"           : "",
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
    }
    
    //MARK: - BarButton Action Methods
    @objc func backButtonAction(sender: UIBarButtonItem){
        cancelTransaction()
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnCVCancelAction(_ sender: UIButton) {
        cancelTransaction()
    }
    
    //MARK: - Custom Methods
    func backToQR() {
        //This method will get back to you transaction view Controller
        
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = Tabbar.coustomTabBar(withIndex: 2)
    }
    
    func cancelTransaction() {
        AlertManager.shared.showAlertTitle(title: "Cancel Transaction?", message: "Are you sure want to cancel this transaction?", buttonsArray: ["NO","YES"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                self.backToQR()
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
                //                self.callPostRemoveAllPOSPayments()
                break
            default:
                break
            }
        }
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
                                    self.backToQR()
                                    break
                                default:
                                    
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
                
                self.posData.payments?.removeAll()
                if self.posData.paymentOptions?.count == 0 {
                    self.posData.paymentOptions = self.paymentOptionsBackUp
                }
                self.posData.balanceRemaining   = self.posData.totalPurchaseAmount
    
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
    
    // MARK: - Navigation
    func detailVC(data: PostCreatePOSModel, tblType: tableType) {
        self.splitViewController?.preferredDisplayMode = .allVisible
        guard let PaymentDetailVC = storyboard?.instantiateViewController(withIdentifier: "TMSplitPaymentDetailVC") as? TMSplitPaymentDetailVC else { return }
        PaymentDetailVC.typeTable   = tblType
        PaymentDetailVC.posData     = data
        
        self.splitViewController?.showDetailViewController(PaymentDetailVC, sender: self)
    }
}

extension TMSplitPaymentMasterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Delegates & DataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/2, height: collectionViewWidth/2)
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
        
        cell.imgV.image         = UIImage(named: arrCV[indexPath.item]["image"]!)
        cell.lblTitle.text      = arrCV[indexPath.item]["title"]
        cell.lblTitle.font      = UIFont.applyOpenSansRegular(fontSize: 10.0)
        cell.contentView.alpha  = GFunction.shared.checkPaymentOptions(withPosData: posData, Method: arrCV[indexPath.item]["method"]!, withViewType: .home) ? 1.0 : 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if mixPayFlag == true {
            AlertManager.shared.showAlertTitle(title: "", message: "Please cancel mix payment method first to countinue with this payment method")
            return
        }
        
        if !GFunction.shared.checkPaymentOptions(withPosData: posData, Method: arrCV[indexPath.item]["method"]!, withViewType: .home) {
            return
        }
        
        if indexPath.row != 5 || indexPath.row != 2 {
            CompletionHandler.shared.triggerEvent(.hideTableContainerPayment, passData: nil)
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
                CompletionHandler.shared.triggerEvent(.svReloadTbl, passData: tableType.card)
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
            CompletionHandler.shared.triggerEvent(.svReloadTbl, passData: tableType.mix)
        }
    }
}
