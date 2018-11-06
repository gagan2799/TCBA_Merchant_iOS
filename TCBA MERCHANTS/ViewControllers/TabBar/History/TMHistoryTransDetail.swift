//
//  TMHistoryTransDetail.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 03/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryTransDetail: UIViewController {
    
    // Modal object
    var posData     : PostCreatePOSModel!
    
    //MARK: Outlets
    @IBOutlet weak var tblHistoryTrans: UITableView!
    @IBOutlet weak var lblTopHeaderTitle: UILabel!
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTnxsVal: UILabel!
    @IBOutlet weak var lblValueVal: UILabel!
    @IBOutlet weak var lblDebitsVal: UILabel!
    @IBOutlet weak var lblCreditsVal: UILabel!
    
    @IBOutlet var lblSubTitles: [UILabel]!
    
    //MARK: Modal objects
    var transactionData: TransactionDataModel!
    var transactionHistory: MerchantTnsxHistoryModel!
    
    //MARK: Variables
    var type : types!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .all {
            callMerchantTransactionHistoryApi(transType: .all)
        }else if type == .today{
            callMerchantTransactionHistoryApi(transType: .today)
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
        self.navigationItem.title   = "History"
        
        if let storeId = GConstant.UserData.stores {
            lblStoreId.text         = "Store id: \(storeId)"
        }
        
        lblMainTitle.text           = type == .all ? "All Transactions" : "Today's Transactions"
        
        lblTopHeaderTitle.font      = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblStoreId.font             = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        
        lblMainTitle.font           = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblTitle.font               = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        
        for lbl in lblSubTitles {
            lbl.font = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        }
        
        lblTnxsVal.font             = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblValueVal.font            = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblDebitsVal.font           = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblCreditsVal.font          = UIFont.applyOpenSansRegular(fontSize: 15.0)
    }
    
    func setHeaderValues(data: MerchantTnsxHistoryModel?) {
        if let transData = data {
            lblTnxsVal.text     = "\(transData.transactionCount ?? 0)"
            lblValueVal.text    = "$\(String.init(format: "%.2f",transData.transactionValue ?? 0.0))"
            lblDebitsVal.text   = "$\(String.init(format: "%.2f", transData.totalDebits ?? 0.0))"
            lblCreditsVal.text  = "$\(String.init(format: "%.2f", transData.totalCredits ?? 0.0))"
        }
    }
    
    //MARK: - Web Api's
    func callMerchantTransactionHistoryApi(transType: TransDetailstypes) {
        /*
         =====================API CALL=====================
         APIName    : TransactionData
         Url        : "/Merchant/MerchantTransactionHistory"
         Method     : GET
         Parameters : { storeID : "", type : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeID     = storeId
        request.type        = transType.rawValue
        let parm            = request.toDictionary()
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetMerchantTransactionHistory, parameter: parm,debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{ return }
                self.transactionHistory = MerchantTnsxHistoryModel.decodeData(_data: data).response
                self.setHeaderValues(data: self.transactionHistory)
                self.tblHistoryTrans.reloadData()
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
}
extension TMHistoryTransDetail: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == .all {
            if transactionHistory != nil{
                return (transactionHistory.transactions?.count)!
            }
        }else if type == .today{
            if transactionHistory != nil{
                return (transactionHistory.transactions?.count)!
            }
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTransDetailHeaaderCell") as! TMHistoryTransDetailCell
//        cell.lblDateOrID.font    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
//        cell.lblMember.font      = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
//        cell.lblPrice.font       = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
//        switch type {
//        case .all?:
//            cell.lblDateOrID.text   = "Date"
//            cell.lblMember.text     = "Member"
//            cell.lblPrice.text      = "Amount"
//            break
//        case .today?:
//            cell.lblDateOrID.text   = "Date"
//            cell.lblMember.text     = "Member"
//            cell.lblPrice.text      = "Amount"
//            break
//        default:
//            cell.lblDateOrID.text   = "Date"
//            cell.lblMember.text     = "Member"
//            cell.lblPrice.text      = "Amount"
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTransDetailCell") as! TMHistoryTransDetailCell
        
//        cell.lblDateOrID.font    = UIFont.applyOpenSansRegular(fontSize: 14.0)
//        cell.lblMember.font      = UIFont.applyOpenSansRegular(fontSize: 14.0)
//        cell.lblPrice.font       = UIFont.applyOpenSansRegular(fontSize: 14.0)
//
//        switch type {
//        case .all?:
//            if let transactions = transactionDetailsData.transactions{
//                let date = Date().dateToDDMMYYYY(date: transactions[indexPath.row].transactionDate!)
//                cell.lblDateOrID.text       = date
//                cell.lblMember.text         = transactions[indexPath.row].customerName
//                cell.lblPrice.text          = "$\(transactions[indexPath.row].transactionAmount!)"
//            }
//            break
//        case .today?:
//            if let transactions     = transactionDetailsData.transactions{
//                let date = Date().dateToDDMMYYYY(date: transactions[indexPath.row].transactionDate!)
//                cell.lblDateOrID.text       = date
//                cell.lblMember.text         = transactions[indexPath.row].customerName
//                cell.lblPrice.text          = "$\(transactions[indexPath.row].transactionAmount!)"
//            }
//            break
//        default: break
//
//        }
        
        return cell
    }
}
