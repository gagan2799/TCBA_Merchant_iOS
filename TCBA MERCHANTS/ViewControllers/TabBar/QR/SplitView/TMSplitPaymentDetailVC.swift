//
//  TMSplitPaymentDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 28/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMSplitPaymentDetailVC: UIViewController {

    //MARK: Modals Object
    var posData         : PostCreatePOSModel!
    var paymentOptionsBackUp  : [PostCreatePOSPaymentOption]!
    //Constraints
    @IBOutlet weak var consHeightTbl: NSLayoutConstraint!
    @IBOutlet weak var consTopV: NSLayoutConstraint!
    
    // Variables
    var arrCV           = [Dictionary<String,String>]()
    var arrTV           = [Dictionary<String,String>]()
    var arrCreditCards  = [PostCreatePOSPaymentOption]()
    var strCCToken      = ""
    var strPinCode      = ""
    
    // Enum Object
    var typeView         : viewType!
    var typeTable        : tableType!
    var typeMethod       : methodType!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        typeTable = .mix
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
        self.navigationController?.topViewController!.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        /*   navigationItem.leftBarButtonItem    = UIBarButtonItem(image: UIImage(named: "back_button"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
         
         lblUserName.font                    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
         lblMemberId.font                    = UIFont.applyOpenSansRegular(fontSize: 15.0)
         
         lblUserName.text                    = posData.memberFullName!
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
         */
        
        // Array for TableView in mix payments
        
        arrTV = [
            ["image"            : "cash_icon",
             "title"            : "Cash or EFTPOS",
             "balance"          : "",
             "selectedAmount"   : "",
             "method"           : "CashOrEFTPOS",
             "posPaymentID"     : ""],
            
            ["image"            : "loyality_icon",
             "title"            : "Loyalty Credits",
             "balance"          : "\(0.00)",
                "selectedAmount"   : "",
                "method"           : "LoyaltyCash",
                "posPaymentID"     : ""],
            
            ["image"            : "wallet_icon",
             "title"            : "Wallet Funds",
             "balance"          : "\(0.00)",
                "selectedAmount"   : "",
                "method"           : "Wallet",
                "posPaymentID"     : ""],
            
            ["image"            : "prizefundtrophy",
             "title"            : "Prize Funds",
             "balance"          : "\(0.00)",
                "selectedAmount"   : "",
                "method"           : "PrizeWallet",
                "posPaymentID"     : ""],
            
            ["image"            : "card_icon",
             "title"            : "Saved Credit Cards",
             "balance"          : "",
             "selectedAmount"   : "",
             "method"           : "TokenisedCreditCard",
             "posPaymentID"     : ""]]
        
        
        // Array of Credit Cards
        //        if let paymentOptions = posData.paymentOptions {
        //            paymentOptionsBackUp = paymentOptions
        //            for item in paymentOptions {
        //                if item.type == "TokenisedCreditCard" {
        //                    arrCreditCards.append(item)
        //                }
        //            }
        //        }
        //        // Top View Height
        consTopV.constant    = GConstant.Screen.Height * 0.3
        // ColectionView Layout setup
        consHeightTbl.constant   = GConstant.Screen.Height * 0.7
        view.setNeedsLayout()
    }
    
    //MARK: - Custom Methods
    func cancelTransaction() {
        AlertManager.shared.showAlertTitle(title: "Cancel Transaction?", message: "Are you sure want to cancel this transaction?", buttonsArray: ["NO","YES"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                let transition: CATransition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                rootWindow().layer.add(transition, forKey: nil)
                rootWindow().rootViewController = Tabbar.coustomTabBar(withIndex: 2)
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
    
    func checkPaymentOptions(withMethod type: String ,withViewType viewT: viewType) -> Bool {
        var flag = type == "" ? true : false
        guard posData != nil  else { return flag}
        guard let data = posData.paymentOptions else { return flag}
        if data.count > 0 {
            for item in data {
                if item.type == type {
                    flag = true
                    break
                }
            }
        } else {
            guard let data2 = posData.payments else { return flag}
            for item in data2 {
                if item.type == type {
                    flag = true
                    break
                }
            }
        }
        
        guard let totalPurchase = posData.totalPurchaseAmount else { return flag}
        guard let walletBal     = posData.walletBalance else { return flag }
        guard let prizeFund     = posData.availablePrizeCash else { return flag }
        guard let loyaltyCash   = posData.availableLoyaltyCash else { return flag }
        if type         == "Wallet"       && (viewT == .home ? walletBal.isLess(than: totalPurchase) : walletBal.isLessThanOrEqualTo(0.0)) {
            flag = false
        }else if type   == "PrizeWallet"  && (viewT == .home ? prizeFund.isLess(than: totalPurchase) : prizeFund.isLessThanOrEqualTo(0.0)) {
            flag = false
        }else if type   == "LoyaltyCash"  && (viewT == .home ? loyaltyCash.isLess(than: totalPurchase) : loyaltyCash.isLessThanOrEqualTo(0.0)) {
            flag = false
        }else if  type == "" {// For mix payments
            flag = true
        }
        return flag
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TMSplitPaymentDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            
            cell.imgVTV.image           = UIImage(named: arrTV[indexPath.item]["image"]!)
            cell.lblTitle.text          = arrTV[indexPath.item]["title"]
            cell.lblBal.text            = "$" + arrTV[indexPath.item]["balance"]!
            
            cell.contentView.alpha      = checkPaymentOptions(withMethod: arrTV[indexPath.item]["method"]!, withViewType: .mixPayment) ? 1.0 : 0.5
            
            if arrTV[indexPath.item]["method"] == "TokenisedCreditCard" || arrTV[indexPath.item]["method"] == "CashOrEFTPOS" {
                cell.lblBal.isHidden        = true
                cell.lblAvailable.isHidden  = true
            }else{
                cell.lblBal.isHidden        = false
                cell.lblAvailable.isHidden  = false
            }
            
            cell.vBlueLine.isHidden     = true
            cell.lblAmtPaid.isHidden    = true
            cell.consLblWidth.constant  = 0.0
            guard posData != nil else { return cell }
            if let payments = posData.payments {
                if payments.count > 0{
                    for item in payments{
                        if item.type == arrTV[indexPath.row]["method"] {
                            cell.vBlueLine.isHidden     = false
                            cell.lblAmtPaid.isHidden    = false
                            cell.consLblWidth.constant  = GConstant.Screen.Width * 0.18
                            cell.lblAmtPaid.text        = arrTV[indexPath.row]["selectedAmount"]
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
        
    /*    if typeTable == .mix {
            if !checkPaymentOptions(withMethod: arrTV[indexPath.row]["method"]!, withViewType: .mixPayment) {
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
        }*/
    }
}
