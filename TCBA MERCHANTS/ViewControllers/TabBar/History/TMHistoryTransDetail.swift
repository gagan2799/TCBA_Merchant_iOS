//
//  TMHistoryTransDetail.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 03/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryTransDetail: UIViewController {
    struct txnsHistoryModal: Codable {
        var isExpandable,isExpanded,isVisible :Bool
        var transactions: MerchantTnsxHistoryTransaction?
    }
    
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
    
    @IBOutlet weak var consWidthTbl: NSLayoutConstraint!
    //MARK: Modal objects
    var transactionData: TransactionDataModel!
    var transactionHistory: MerchantTnsxHistoryModel!
    var txnsHistory = [txnsHistoryModal]()
    
    
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
        
        consWidthTbl.constant       = 800*GConstant.Screen.HeightAspectRatio
        tblHistoryTrans.layoutIfNeeded()
        
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
    
    //MARK: - IBAction methods
    @objc func btnDropDownAction(_ sender: UIButton) {
        print("dropDown pressed \(sender.tag)")
        let indexPath           = IndexPath.init(item: sender.tag, section: 0)
        
        
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
            
                if let transactions = self.transactionHistory?.transactions {
                    for tranaction in transactions {
                        let rowData = txnsHistoryModal.init(isExpandable: tranaction.payments?.count != 0 ? true : false , isExpanded: false, isVisible: false, transactions: tranaction)
                        self.txnsHistory.append(rowData)
                    }
                }
                
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
                return txnsHistory.count
            }
        }else if type == .today{
            if transactionHistory != nil{
                return txnsHistory.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTransDetailHeaaderCell") as! TMHistoryTransDetailCell
        let fontSize                        = CGFloat(15.0)
        cell.btnDropDown.titleLabel?.font   = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblDate.font                   = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblDetail.font                 = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblAmount.font                 = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblCredits.font                = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblDebits.font                 = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblNet.font                    = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        cell.lblBalance.font                = UIFont.applyOpenSansSemiBold(fontSize: fontSize)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isExpandable                    = txnsHistory[indexPath.row].isExpandable
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTransDetailCell") as! TMHistoryTransDetailCell
        
        let fontSize                        = CGFloat(14.0)
        cell.btnDropDown.titleLabel?.font   = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblDate.font                   = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblDetail.font                 = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblAmount.font                 = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblCredits.font                = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblDebits.font                 = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblNet.font                    = UIFont.applyOpenSansRegular(fontSize: fontSize)
        cell.lblBalance.font                = UIFont.applyOpenSansRegular(fontSize: fontSize)
        
        cell.btnDropDown.setImage(isExpandable ? UIImage(named: "arrow_dropdown_black") : nil, for: .normal)
        cell.btnDropDown.tag                = indexPath.row
        cell.btnDropDown.addTarget(self, action: #selector(btnDropDownAction(_:)), for: .touchUpInside)
        
        //2018-07-19T01:22:09.15Z = YYYY-MM-dd'T'HH:mm:ss.SSS
        cell.lblDate.text                   = transactionHistory?.transactions?[indexPath.row].createDate?.applyDateWithFormat(format: "YYYY-MM-dd'T'HH:mm:ss.SSS" ,outPutFormat: "dd/MM/yyyy HH:mm:ss")
        cell.lblDetail.text                 = txnsHistory[indexPath.row].transactions?.title
        cell.lblAmount.text                 = "$\(txnsHistory[indexPath.row].transactions?.amount ?? 0.00)"
        cell.lblCredits.text                = "$\(txnsHistory[indexPath.row].transactions?.credits ?? 0.00)"
        cell.lblDebits.text                 = "$\(txnsHistory[indexPath.row].transactions?.debits ?? 0.00)"
        cell.lblNet.text                    = "$\(txnsHistory[indexPath.row].transactions?.net ?? 0.00)"
        cell.lblBalance.text                = "$\(txnsHistory[indexPath.row].transactions?.runningBalance ?? 0.00)"
        
        return cell
    }
}
