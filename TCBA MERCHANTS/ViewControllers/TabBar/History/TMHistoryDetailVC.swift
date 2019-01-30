//
//  TMHistoryDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 07/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

enum types: UInt {
    case all
    case today
    case incomplete
    case outstanding
}
enum TransDetailstypes: String {
    case all            = "all"
    case today          = "today"
    case outstanding    = "outstanding"
}

class TMHistoryDetailVC: UIViewController {
    
    // Modal object
    var posData     : PostCreatePOSModel!
    
    //MARK: Outlets
    @IBOutlet weak var tblHistoryDetails: UITableView!
    @IBOutlet weak var lblTopHeaderTitle: UILabel!
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalDebValue: UILabel!
    @IBOutlet weak var lblTransaction: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet var lblSubTitles: [UILabel]!
    @IBOutlet weak var stackVDebits: UIStackView!
    
    @IBOutlet weak var consHeightTotalView: NSLayoutConstraint!
    //MARK: Modal objects
    var transactionData         : TransactionDataModel!
    var incompleteData          : IncompleteTransactionDataModel!
    var transactionDetailsData  : TransactionDetailsModel!
    var outstandingData         : OutstandingLoyaltyModel!
    
    //MARK: Variables
    var type : types!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .all {
            callTransactionDetailsApi(transType: .all)
        }else if type == .today{
            callTransactionDetailsApi(transType: .today)
        }else if type == .incomplete{
            
        }else if type == .outstanding{
            callTransactionDetailsApi(transType: .outstanding)
        }
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            switch orient {
                
            case .portrait:
                
                print("Portrait")
                
            case .landscapeLeft,.landscapeRight :
                
                print("Landscape")
                
            default:
                
                print("Anything But Portrait")
            }
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title = "History"
        
        consHeightTotalView.constant = GConstant.Screen.iPhoneXSeries ? GConstant.Screen.Height * 0.16 : GConstant.Screen.Height * 0.2
        
        if let storeId = GConstant.UserData.stores {
            lblStoreId.text       = "Store ID: \(storeId)"
        }
        lblMainTitle.font                  = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblTitle.font                      = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblTotalDebValue.font              = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblValue.font                      = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblTransaction.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        lblTopHeaderTitle.font             = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblStoreId.font                    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        
        for lbl in lblSubTitles {
            lbl.font = UIFont.applyOpenSansRegular(fontSize: 15.0)
        }
        
        if type == .all {
            print("All")
            setPropForAll()
        }else if type == .today{
            print("today")
            setPropForToday()
        }else if type == .incomplete{
            print("incomplete")
            setPropIncomplete()
        }else if type == .outstanding{
            print("outstanding")
            setPropForOutstanding()
        }
    }
    
    func setPropForAll() {
        lblMainTitle.text = "All Transactions"
        if let transData = transactionData {
            lblTotalDebValue.text  = "$\(String.init(format: "%.2f", transData.totalCashBack!))"
            lblTransaction.text    = "\(transData.totalTransaction!)"
            lblValue.text          = "$\(String.init(format: "%.2f",transData.totalAmount!))"
        }
    }
    
    func setPropForToday() {
        lblMainTitle.text = "Today's Transactions"
        if let transData = transactionData {
            lblTotalDebValue.text  = "$\(String.init(format: "%.2f",transData.todayCashBack!))"
            lblTransaction.text    = "\(transData.todayTransaction!)"
            lblValue.text          = "$\(String.init(format: "%.2f",transData.todayAmount!))"
        }
    }
    
    func setPropIncomplete() {
        lblMainTitle.text = "Incomplete Transactions"
        if let incompleteData = incompleteData {
            var totalDebits = 0.00
            var totalValue  = 0.00
            for dic in incompleteData {
                totalValue   += dic.balanceRemaining ?? 0.00
                totalDebits  += dic.totalPurchaseAmount ?? 0.00
            }
            lblTransaction.text    = "\(incompleteData.count)"
            lblValue.text          = "$\(String.init(format: "%.2f", totalValue))"
            lblTotalDebValue.text  = "$\(String.init(format: "%.2f", totalDebits))"
        }
    }
    
    func setPropForOutstanding() {
        lblMainTitle.text       = "Outstanding Loyalty Balances"
        lblSubTitles[0].text    = "Members"
        lblSubTitles[1].text    = "Value"
        stackVDebits.isHidden   = true
        if let data = outstandingData {
            lblTransaction.text    = "\(data.totalNumber!)"
            lblValue.text          = "$\(String.init(format: "%.2f", data.totalOutstanding!))"
        }
    }
    
    //MARK: - Web Api's
    func callTransactionDetailsApi(transType: TransDetailstypes) {
        /*
         =====================API CALL=====================
         APIName    : TransactionData
         Url        : outstanding ? "/Merchant/GetOutstandingLoyalty" : "/Merchant/GetMerchantTransactionDetail"
         Method     : GET
         Parameters : { storeID : "",
         type    : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeID     = storeId
        request.type        = transType.rawValue
        let parm            = transType == .outstanding ? nil : request.toDictionary()
        let url             = transType == .outstanding ? GAPIConstant.Url.GetOutstandingLoyalty : GAPIConstant.Url.GetMerchantTransactionDetail
        
        ApiManager.shared.GETWithBearerAuth(strURL: url, parameter: parm,debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                if transType == .outstanding{
                    self.outstandingData        = try! OutstandingLoyaltyModel.decode(_data: data)
                    self.setPropForOutstanding()
                }else{
                    self.transactionDetailsData = try! TransactionDetailsModel.decode(_data: data)
                }
                
                self.tblHistoryDetails.reloadData()
            }else{
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
    
    func callIncompleteGetPOSApi(posID: Int) {
        /*
         =====================API CALL=====================
         APIName    : GetPOS
         Url        : "/Payment/POS/GetPOS"
         Method     : POST
         Parameters : { staffId      : 0,
         keyChainCode : 19,
         totalAmount  : 3.65, // minimum Amount should be $3
         memberID     : 19,
         storeID      : 283
         }
         ===================================================
         */
        let request             = RequestModal.mCreatePOS()
        request.posID           = posID
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetPOS, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("statusCode = 200")
                guard data != nil else{return}
                if let pData = try? PostCreatePOSModel.decode(_data: data!) {
                    self.posData    = pData
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        self.masterVC(data: self.posData)
                    }else {
                        self.pushToPaymentVC(data: self.posData)
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
    
    // MARK: - Navigation
    func pushToPaymentVC(data: PostCreatePOSModel) {
        rootWindow().rootViewController = Tabbar.coustomTabBar(withIndex: 2)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            CompletionHandler.shared.triggerEvent(.pushToPayment, passData: data)
        })
    }
    
    func masterVC(data: PostCreatePOSModel) {
        guard let splitViewController       = storyboard?.instantiateViewController(withIdentifier: "SplitVC") as? UISplitViewController else { fatalError() }
        
        let nc : UINavigationController     = splitViewController.viewControllers[0] as! UINavigationController
        
        let vcm : TMSplitPaymentMasterVC    = nc.viewControllers[0] as! TMSplitPaymentMasterVC
        vcm.posData = data
        
        let vcd : TMSplitPaymentDetailVC    = splitViewController.viewControllers[1] as! TMSplitPaymentDetailVC
        vcd.posData                         = data
        vcd.typeTable                       = .mix
        
        //Make sure pass data to Master & Details before setting preferredDisplayMode = .allVisible
        splitViewController.preferredDisplayMode = .allVisible
        
        let transition: CATransition    = CATransition()
        transition.duration             = 0.3
        transition.type                 = CATransitionType.fade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = splitViewController
    }
}
extension TMHistoryDetailVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == .all {
            if transactionDetailsData != nil{
                return (transactionDetailsData.transactions?.count)!
            }
        }else if type == .today{
            if transactionDetailsData != nil{
                return (transactionDetailsData.transactions?.count)!
            }
        }else if type == .incomplete{
            if incompleteData != nil{
                return incompleteData.count
            }
        }else if type == .outstanding{
            if outstandingData != nil{
                return (outstandingData.outstandingLoyalty?.count)!
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellHeader") as! TMHistoryDetailTableCell
        cell.lblDateOrID.font    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        cell.lblMember.font      = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        cell.lblPrice.font       = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        switch type {
        case .all?:
            cell.lblDateOrID.text   = "Date"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "Amount"
            break
        case .today?:
            cell.lblDateOrID.text   = "Date"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "Amount"
            break
        case .incomplete?:
            cell.lblDateOrID.text   = "Member ID"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "Amount"
            break
        case .outstanding?:
            cell.lblDateOrID.text   = "Id"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "Amount"
            break
        default:
            cell.lblDateOrID.text   = "Date"
            cell.lblDateOrID.text   = "Member"
            cell.lblDateOrID.text   = "Amount"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellDetails") as! TMHistoryDetailTableCell
        
        cell.lblDateOrID.font    = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblMember.font      = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblPrice.font       = UIFont.applyOpenSansRegular(fontSize: 14.0)
        
        switch type {
        case .all?:
            if let transactions = transactionDetailsData.transactions{
                let date = Date().dateToDDMMYYYY(date: transactions[indexPath.row].transactionDate!)
                cell.lblDateOrID.text       = date
                cell.lblMember.text         = transactions[indexPath.row].customerName
                cell.lblPrice.text          = "$\(transactions[indexPath.row].transactionAmount!)"
            }
            break
        case .today?:
            if let transactions     = transactionDetailsData.transactions{
                let date = Date().dateToDDMMYYYY(date: transactions[indexPath.row].transactionDate!)
                cell.lblDateOrID.text       = date
                cell.lblMember.text         = transactions[indexPath.row].customerName
                cell.lblPrice.text          = "$\(transactions[indexPath.row].transactionAmount!)"
            }
            break
        case .incomplete?:
            if let incompData   = incompleteData{
                cell.imgVArrowNext.isHidden = false
                cell.lblDateOrID.text       = "\(incompData[indexPath.row].memberID!)"
                cell.lblMember.text         = incompData[indexPath.row].memberFullName
                cell.lblPrice.text          = "$\(incompData[indexPath.row].totalPurchaseAmount!)"
            }
            break
        case .outstanding?:
            if let outData = outstandingData.outstandingLoyalty{
                cell.lblDateOrID.text       = "\(outData[indexPath.row].id!)"
                cell.lblMember.text         = outData[indexPath.row].name
                cell.lblPrice.text          = "$\(outData[indexPath.row].available!)"
            }
            break
        default: break
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .incomplete {
            AlertManager.shared.showAlertTitle(title: "Complete Transaction", message: "Open this transaction in the QR tab and complete purchase.", buttonsArray: ["Cancel","Open"]) { (buttonIndex : Int) in
                switch buttonIndex {
                case 0 :
                    //No clicked
                    
                    break
                case 1:
                    // OpenQRPayment
                    guard self.incompleteData != nil else { return }
                    guard let posid = self.incompleteData[indexPath.row].posid else { return }
                    self.callIncompleteGetPOSApi(posID: posid)
                    break
                default:
                    break
                }
            }
        }
    }
}
