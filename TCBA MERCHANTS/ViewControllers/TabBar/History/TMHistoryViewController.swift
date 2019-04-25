//
//  TMHistoryViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var viewOutstanding: UIView!
    @IBOutlet weak var lblOutStanding: UILabel!
    @IBOutlet weak var lblOutstandingValue: UILabel!
    @IBOutlet weak var viewLock: UIView!
    
    //MARK: Variables
    let arrTitles               = ["All Transactions","Today's Transactions","Incomplete Transactions"]
    var incompleteTransaction   = 0.00
    var incompleteValue         = 0.00
    
    //MARK: Modal objects
    var transactionData : TransactionDataModel!
    var incompleteData  : IncompleteTransactionDataModel!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            tblHistory.isScrollEnabled  = true
        }else{
            tblHistory.isScrollEnabled  = false
        }
        
        if UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.EnableStaffMode) == true && UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.isStaffLoggedIn) == false {
            DispatchQueue.main.async {
                self.viewLock.isHidden  = false
            }
        } else {
            DispatchQueue.main.async {
                self.viewLock.isHidden  = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.transactionData == nil || self.incompleteData == nil {
                    // Calling TransactionData Api
                    self.callTransactionDataApi()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard tblHistory != nil else {return}
        if UIDevice.current.orientation.isLandscape == true  {
            tblHistory.isScrollEnabled = true
        }else{
            tblHistory.isScrollEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        guard tblHistory != nil else {return}
        
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "History"
        
        if let storeId = GConstant.UserData.stores {
            lblStoreId.text         = "Store ID: \(storeId)"
        }
        viewOutstanding.frame       = CGRect(x: 0, y: 0, width: GConstant.Screen.Width, height: GConstant.Screen.Height * 0.07)
        lblOutStanding.font         = UIFont.applyOpenSansRegular(fontSize: 16.0)
        lblOutstandingValue.font    = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblCashBack.font            = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblStoreId.font             = UIFont.applyOpenSansRegular(fontSize: 15.0)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnOutStandingAction(_ sender: UIButton) {
        let obj  = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.HistoryDetail) as! TMHistoryDetailVC
        obj.type = .outstanding
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @objc func btnViewDetailsAction(sender: UIButton) {
        print(sender.tag)
        if sender.tag == 0 || sender.tag == 1{
            let obj = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.HistoryTransDetail) as! TMHistoryTransDetail
            guard transactionData != nil else{return}
            obj.transactionData = transactionData
            obj.type            = sender.tag == 0 ? .all : .today
            self.navigationController?.pushViewController(obj, animated: true)
        }else{
            let obj = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.HistoryDetail) as! TMHistoryDetailVC
            guard incompleteData != nil else{return}
            obj.incompleteData  = incompleteData
            obj.type            = .incomplete
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    @IBAction func btnLock(_ sender: UIButton) {
        staffLoginVC()
    }
    
    //MARK: - Web Api's
    func callTransactionDataApi() {
        /*
         =====================API CALL=====================
         APIName    : TransactionData
         Url        : "/Merchant/GetMerchantTransactionSummary"
         Method     : GET
         Parameters : nil
         ===================================================
         */
        
        //Add Loder in this Api and removed in incomplete api
        GFunction.shared.addLoader()
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.TransactionData, parameter: nil, withLoader : false) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.transactionData = TransactionDataModel.decodeData(_data: data).response
                if let outstanding = self.transactionData.outstandingLoyalty {
                    self.lblOutstandingValue.text = "$\(outstanding)"
                }
                // Calling IncompleteTransactionData Api
                self.callIncompleteTransactionDataApi()
            }else{
                GFunction.shared.removeLoader()
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
                        guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
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
    
    func callIncompleteTransactionDataApi() {
        /*
         =====================API CALL=====================
         APIName    : IncompleteTransactionData
         Url        : "/Payment/POS/GetIncompletePOSes"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        let request = RequestModal.mUserData()
        guard let storeId = GConstant.UserData.stores else{return}
        request.storeID = storeId
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.IncompleteTransactionData, parameter: request.toDictionary(), withLoader : false) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.incompleteData = try! IncompleteTransactionDataModel.decode(_data: data)
                for dic in self.incompleteData {
                    self.incompleteValue  += dic.balanceRemaining!
                }
                self.incompleteTransaction = Double(self.incompleteData.count)
                self.tblHistory.reloadData()
                GFunction.shared.removeLoader()
            }else{
                GFunction.shared.removeLoader()
                self.tblHistory.reloadData()
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data {
                        guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
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
    
    //MARK: CheckStaffLogin Method & Api
    func staffLoginVC() {
        let obj = storyboard?.instantiateViewController(withIdentifier: "TMStaffLoginVC") as! TMStaffLoginVC
        obj.userT = .staff
        obj.modalPresentationStyle = .overCurrentContext
        obj.completionHandler   = { (pin) in
            self.callGetStaffLoginApi(pin: pin)
        }
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    func callGetStaffLoginApi(pin: String) {
        /*
         =====================API CALL=====================
         APIName    : GetStaffLogin
         Url        : "/Staff/GetStaffLogin"
         Method     : GET
         Parameters : { storeID : "", pinCode : "" }
         ===================================================
         */
        let request = RequestModal.mCreatePOS()
        guard let storeId = GConstant.UserData.stores else { return }
        request.storeId = storeId
        request.pinCode = pin
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStaffLogin, parameter: request.toDictionary(), withLoader : false) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    self.viewLock.isHidden  = true
                    UserDefaults.standard.set(true, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
                    UserDefaults.standard.synchronize()
                }
                
                if self.transactionData == nil || self.incompleteData == nil {
                    // Calling TransactionData Api
                    self.callTransactionDataApi()
                }
                
            }else{
                AlertManager.shared.showAlertTitle(title: "Incorrect PIN" ,message:"Your pin is incorrect, please try again.")
            }
        }
    }
}
extension TMHistoryViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! TMHistoryTableViewCell
        
        cell.lblTitle.text = arrTitles[indexPath.row]
        
        cell.lblTitle.font                      = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        cell.lblTotalDebValue.font              = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        cell.lblTotalDebs.font                  = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblValue.font                      = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.lblSubTitles[0].font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.lblSubTitles[1].font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.lblTransaction.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.btnViewDetails.titleLabel?.font    = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        if indexPath.row == 2 {cell.viewOrange.isHidden = true}
        
        if (transactionData) != nil {
            if indexPath.row == 0 {
                cell.lblTotalDebValue.text  = "$\(String.init(format: "%.2f",  transactionData.totalCashBack!))"
                cell.lblTransaction.text    = "\(Int(transactionData.totalTransaction ?? 0))"
                cell.lblValue.text          = "$\(String.init(format: "%.2f", transactionData.totalAmount!))"
            }else if indexPath.row == 1{
                cell.lblTotalDebValue.text  = "$\(String.init(format: "%.2f", transactionData.todayCashBack!))"
                cell.lblTransaction.text    = "\(Int(transactionData.todayTransaction ?? 0))"
                cell.lblValue.text          = "$\(String.init(format: "%.2f", transactionData.todayAmount!))"
            } else {
                cell.lblTransaction.text    = "\(Int(incompleteTransaction))"
                cell.lblValue.text          = "$\(String.init(format: "%.2f", incompleteValue))"
            }
            cell.btnViewDetails.tag = indexPath.row
            cell.btnViewDetails.addTarget(self, action: #selector(btnViewDetailsAction), for: UIControl.Event.touchUpInside)
        }
        return cell
    }
}
