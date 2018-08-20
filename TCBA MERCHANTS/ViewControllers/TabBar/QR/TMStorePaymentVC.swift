//
//  TMStorePaymentVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 17/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMStorePaymentVC: UIViewController {
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
    }
    //MARK: Modals Object
    var posData     : PostCreatePOSModel!
    
    //MARK: Outlets & Variables
    
    // Variables
    var arrCV           = [Dictionary<String,String>]()
    var arrTV           = [Dictionary<String,String>]()
    var arrCreditCards  = [Any]()
    
    // Enum Object
    var enmView         : viewType!
    var enmTbl          : tableType!
    var enmMethod       : methodType!
    

    // UIImageView
    @IBOutlet weak var imgVUser: RoundedImage!
    
    // UILabels
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMemberId: UILabel!
    
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
        //        navigationItem.leftBarButtonItem    = UIBarButtonItem(image: UIImage(named: "backImg"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem    = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonAction))
        
        lblUserName.font                    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblMemberId.font                    = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        lblUserName.text                    = posData.memberFullName!
        lblMemberId.text                    = "Member Id: \(posData.memberID ?? 0)"
        guard let urlProfile = URL.init(string: posData.profileImageURL ?? "") else {return}
        imgVUser.setImageWithDownload(urlProfile, withIndicator: true)
        
        
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
             "balance"          : "\(posData.walletBalance ?? 0.0)",
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
             "balance"          : "\(posData.availablePrizeCash ?? 0.0)",
             "selectedAmount"   : "",
             "method"           : "PrizeWallet",
             "posPaymentID"     : ""],
            
            ["image"            : "loyality_icon",
             "title"            : "Loyalty Credits",
             "balance"          : "\(posData.availableLoyaltyCash ?? 0.0)",
             "selectedAmount"   : "",
             "method"           : "LoyaltyCash",
             "posPaymentID"     : ""],
            
            ["image"            : "mixpayment",
             "title"            : "Mixed Payment",
             "balance"          : "",
             "selectedAmount"   : "",
             "method"           : "",
             "posPaymentID"     : ""]]
        
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
             "balance"          : "\(posData.availableLoyaltyCash ?? 0.0)",
             "selectedAmount"   : "",
             "method"           : "LoyaltyCash",
             "posPaymentID"     : ""],
            
            ["image"            : "wallet_icon",
             "title"            : "Wallet Funds",
             "balance"          : "\(posData.walletBalance ?? 0.0)",
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
             "balance"          : "\(posData.availablePrizeCash ?? 0.0)",
             "selectedAmount"   : "",
             "method"           : "PrizeWallet",
             "posPaymentID"     : ""]]
        
        // Array of Credit Cards
        if let paymentOptions = posData.paymentOptions {
            for item in paymentOptions {
                if item.type == "TokenisedCreditCard" {
                    arrCreditCards.append(item)
                }
            }
        }
    }
    
    //MARK: - BarButton items
    @objc func backButtonAction(sender: UIBarButtonItem){
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
                self.navigationController?.popToRootViewController(animated: true)
                break
            default:
                break
            }
        }
    }
    
    func checkPaymentOptions(withMethod type: String ,withViewType viewT: viewType) -> Bool {
        var flag = false
        guard let data = posData.paymentOptions else { return flag}
        for item in data {
            if item.type == type || type == ""{
                flag = true
                break
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
        }
        return flag
    }
    
    // MARK: - Navigation
    
}
extension TMStorePaymentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Delegates & DataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/3)
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
        
    }

    //MARK: TableView Delegates & DataSource
}
