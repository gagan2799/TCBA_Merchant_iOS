//
//  TMSplitPaymentMasterVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 28/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMSplitPaymentMasterVC: UIViewController {

    //MARK: Modals Object
    var posData         : PostCreatePOSModel!
    var paymentOptionsBackUp  : [PostCreatePOSPaymentOption]!
    //Constraints
    @IBOutlet weak var consHeightCol: NSLayoutConstraint!
    @IBOutlet weak var consTopView: NSLayoutConstraint!
    
    // Variables
    var arrCV           = [Dictionary<String,String>]()
    var arrTV           = [Dictionary<String,String>]()
    var arrCreditCards  = [PostCreatePOSPaymentOption]()
    var strCCToken      = ""
    var strPinCode      = ""
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(posData)
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
        
        
        // Array For Collecion View
        arrCV = [
            ["image"            : "cash_icon",
             "title"            : "Cash or EFTPOS",
             "balance"          : "",
             "selectedAmount"   : "",
             "method"           : "CashOrEFTPOS",
             "posPaymentID"     : ""],
            
            ["image"            : "wallet_icon",
             "title"            : "Wallet Funds",
             "balance"          : "\(posData.walletBalance ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "Wallet",
                "posPaymentID"     : ""],
            
            ["image"            : "card_icon",
             "title"            : "Saved Credit Cards",
             "balance"          : "",
             "selectedAmount"   : "",
             "method"           : "TokenisedCreditCard",
             "posPaymentID"     : ""],
            
            ["image"            : "prizefundtrophy",
             "title"            : "Prize Funds",
             "balance"          : "\(posData.availablePrizeCash ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "PrizeWallet",
                "posPaymentID"     : ""],
            
            ["image"            : "loyality_icon",
             "title"            : "Loyalty Credits",
             "balance"          : "\(posData.availableLoyaltyCash ?? 0.00)",
                "selectedAmount"   : "",
                "method"           : "LoyaltyCash",
                "posPaymentID"     : ""],
            
            ["image"            : "mixpayment",
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
        
        // Top View Height
        consTopView.constant    = GConstant.Screen.Height * 0.3
        // ColectionView Layout setup
        consHeightCol.constant   = GConstant.Screen.Height * 0.5
        view.setNeedsLayout()
    }
    
    @IBAction func btnCVCancelAction(_ sender: UIButton) {
        cancelTransaction()
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

    // MARK: - Navigation
    func detailVC(data: PostCreatePOSModel) {
        self.splitViewController?.preferredDisplayMode = .automatic
        guard let PaymentDetailVC = storyboard?.instantiateViewController(withIdentifier: "TMSplitPaymentDetailVC") as? TMSplitPaymentDetailVC else { return }
        let navController = UINavigationController(rootViewController: PaymentDetailVC)
        self.splitViewController?.showDetailViewController(navController, sender: self)
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
        return arrCV.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! TMStorePaymentCVCell
        
        cell.imgV.image         = UIImage(named: arrCV[indexPath.item]["image"]!)
        cell.lblTitle.text      = arrCV[indexPath.item]["title"]
        cell.lblTitle.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
        cell.contentView.alpha  = checkPaymentOptions(withMethod: arrCV[indexPath.item]["method"]!, withViewType: .home) ? 1.0 : 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !checkPaymentOptions(withMethod: arrCV[indexPath.item]["method"]!, withViewType: .home) {
            return
        }
        
        if indexPath.row == 0 {
            //<===CashOrEFTPOS===>
//            showPopUp(withMethod: .CashOrEFTPOS, transactionAmount: posData.balanceRemaining, completion: {(amount) in
//                self.callPostCreateTransactionWithFullPayment(payMethodType: .CashOrEFTPOS)
//            })
        } else if indexPath.row == 1 {
            //<===Wallet===>
            if (posData.walletBalance?.isLess(than: posData.balanceRemaining!))!{
                AlertManager.shared.showAlertTitle(title: "Insufficent Funds", message: String(format: "You do not have enough funds.\nCurrent balance is $%.2f.\nPlease try another method or pay with Mixed Payment", posData.walletBalance!))
            }else{
//                showPin(withMethod: .Wallet, currentBalance: posData.walletBalance, transactionAmount: posData.balanceRemaining) { (pinCode) in
//                    self.callPostCreateTransactionWithFullPayment(payMethodType: .Wallet, withPin: pinCode)
//                }
            }
        } else if indexPath.row == 2 {
            //<===TokenisedCreditCard===>
            if arrCreditCards.count == 0{
                AlertManager.shared.showAlertTitle(title: "", message: "Please attach a credit card to your wallet to use this feature.")
            }else{
//                typeView = .home
//                reloadTableView(withTblType: .card)
//                viewTable.animateHideShow()
            }
        } else if indexPath.row == 3 {
            //<===PrizeWallet===>
            if (posData.walletBalance?.isLess(than: posData.balanceRemaining!))!{
                AlertManager.shared.showAlertTitle(title: "Insufficent Funds", message: String(format: "You do not have enough funds.\nCurrent balance is $%.2f.\nPlease try another method or pay with Mixed Payment", posData.availablePrizeCash!))
            }else{
//                showPin(withMethod: .PrizeWallet, currentBalance: posData.walletBalance, transactionAmount: posData.balanceRemaining) { (pinCode) in
//                    self.callPostCreateTransactionWithFullPayment(payMethodType: .PrizeWallet, withPin: pinCode)
//                }
            }
        } else if indexPath.row == 4 {
            //<===LoyaltyCash===>
            if (posData.walletBalance?.isLess(than: posData.balanceRemaining!))!{
                AlertManager.shared.showAlertTitle(title: "Insufficent Funds", message: String(format: "You do not have enough funds.\nCurrent balance is $%.2f.\nPlease try another method or pay with Mixed Payment", posData.availableLoyaltyCash!))
            }else{
//                showPin(withMethod: .LoyaltyCash, currentBalance: posData.walletBalance, transactionAmount: posData.balanceRemaining) { (pinCode) in
//                    self.callPostCreateTransactionWithFullPayment(payMethodType: .LoyaltyCash, withPin: pinCode)
//                }
            }
        } else if indexPath.row == 5 {
            //<===MixPayments===>

        }
    }
}
