//
//  TMHistoryDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 07/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryDetailVC: UIViewController {
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
    
    //MARK: Variables
    var transactionData         : TransactionDataModel!
    var incompleteData          : IncompleteTransactionDataModel!
    var transactionDetailsData  : TransactionDetailsModel!
    var outstandingData         : OutstandingLoyaltyModel!
    
    
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

        if let storeId = GConstant.UserData.stores {
            lblStoreId.text       = "Store id: \(storeId)"
        }
        lblMainTitle.font                  = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblTitle.font                      = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblTotalDebValue.font              = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
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
            lblTotalDebValue.text  = "$\(transData.totalCashBack!)"
            lblTransaction.text    = "\(transData.totalTransaction!)"
            lblValue.text          = "$\(transData.totalAmount!)"
        }
    }
    
    func setPropForToday() {
        lblMainTitle.text = "Today's Transactions"
        if let transData = transactionData {
            lblTotalDebValue.text  = "$\(transData.todayCashBack!)"
            lblTransaction.text    = "\(transData.todayTransaction!)"
            lblValue.text          = "$\(transData.todayAmount!)"
        }
    }
    
    func setPropIncomplete() {
        lblMainTitle.text = "Incomplete Transactions"
        if let incompleteData = incompleteData {
            var totalDebits = 0.00
            for dic in incompleteData {
                totalDebits  += dic.totalPurchaseAmount!
            }
            lblTotalDebValue.text  = "$\(totalDebits)"
            lblTransaction.text    = "\(incompleteData.count)"
            lblValue.text          = "$\(totalDebits)"
        }
    }
    
    func setPropForOutstanding() {
        lblMainTitle.text       = "Outstanding Loyalty Balances"
        lblSubTitles[2].text    = "Total Loyalty"
        if let data = outstandingData {
            lblTransaction.text    = "\(data.totalNumber!)"
            lblValue.text          = "$\(data.totalOutstanding!)"
            lblTotalDebValue.text  = "$\(data.totalOutstanding!)"
        }
    }
    
    //MARK: - Web Api's
    func callTransactionDetailsApi(transType: TransDetailstypes) {
        /*
         =====================API CALL=====================
         APIName    : TransactionData
         Url        : "/Merchant/GetMerchantTransactionSummary"
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
        let url             = transType == .outstanding ? GAPIConstant.Url.GetOutstandingLoyalty : GAPIConstant.Url.HistoryTransactionDetails
        
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
                    let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : String]
                    guard let strDescription = json!["message"] else {return}
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: strDescription)
                }
            }
        }
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
        case .all:
            cell.lblDateOrID.text   = "Date"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "$"
            break
        case .today:
            cell.lblDateOrID.text   = "Date"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "$"
            break
        case .incomplete:
            cell.lblDateOrID.text   = "Member ID"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "$"
            break
        case .outstanding:
            cell.lblDateOrID.text   = "id"
            cell.lblMember.text     = "Member"
            cell.lblPrice.text      = "Loyalty"
            break
        default:
            cell.lblDateOrID.text   = "Date"
            cell.lblDateOrID.text   = "Member"
            cell.lblDateOrID.text   = "$"
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
        case .all:
            if let transactions = transactionDetailsData.transactions{
                let date = Date().dateToDDMMYYYY(date: transactions[indexPath.row].transactionDate!)
                cell.lblDateOrID.text       = date
                cell.lblMember.text         = transactions[indexPath.row].customerName
                cell.lblPrice.text          = "$\(transactions[indexPath.row].transactionAmount!)"
            }
            break
        case .today:
            if let transactions     = transactionDetailsData.transactions{
                let date = Date().dateToDDMMYYYY(date: transactions[indexPath.row].transactionDate!)
                cell.lblDateOrID.text       = date
                cell.lblMember.text         = transactions[indexPath.row].customerName
                cell.lblPrice.text          = "$\(transactions[indexPath.row].transactionAmount!)"
            }
            break
        case .incomplete:
            if let incompData   = incompleteData{
                cell.imgVArrowNext.isHidden = false
                cell.lblDateOrID.text       = "\(incompData[indexPath.row].memberID!)"
                cell.lblMember.text         = incompData[indexPath.row].memberFullName
                cell.lblPrice.text          = "$\(incompData[indexPath.row].totalPurchaseAmount!)"
            }
            break
        case .outstanding:
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
            
        }
    }
}
