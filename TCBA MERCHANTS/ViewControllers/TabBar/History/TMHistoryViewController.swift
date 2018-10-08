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
        if transactionData == nil || incompleteData == nil {
            // Calling TransactionData Api
            callTransactionDataApi()
        }
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            tblHistory.isScrollEnabled = true
        }else{
            tblHistory.isScrollEnabled = false
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
        self.navigationItem.title = "History"
        
        if let storeId = GConstant.UserData.stores {
            lblStoreId.text       = "Store id: \(storeId)"
        }
        viewOutstanding.frame = CGRect(x: 0, y: 0, width: GConstant.Screen.Width, height: GConstant.Screen.Height * 0.07)
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
        let obj = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.HistoryDetail) as! TMHistoryDetailVC
        
        if sender.tag == 0 {
            guard transactionData != nil else{return}
            obj.transactionData = transactionData
            obj.type            = .all
        }else if sender.tag == 1{
            guard transactionData != nil else{return}
            obj.transactionData = transactionData
            obj.type            = .today
        }else{
            guard incompleteData != nil else{return}
            obj.incompleteData  = incompleteData
            obj.type            = .incomplete
        }
        self.navigationController?.pushViewController(obj, animated: true)
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
                self.transactionData = try! TransactionDataModel.decode(_data: data)
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
                cell.lblTransaction.text    = "\(transactionData.totalTransaction!)"
                cell.lblValue.text          = "$\(String.init(format: "%.2f", transactionData.totalAmount!))"
            }else if indexPath.row == 1{
                cell.lblTotalDebValue.text  = "$\(String.init(format: "%.2f", transactionData.todayCashBack!))"
                cell.lblTransaction.text    = "\(transactionData.todayTransaction!)"
                cell.lblValue.text          = "$\(String.init(format: "%.2f", transactionData.todayAmount!))"
            } else {
                cell.lblTransaction.text    = "\(incompleteTransaction)"
                cell.lblValue.text          = "$\(String.init(format: "%.2f", incompleteValue))"
            }
            cell.btnViewDetails.tag = indexPath.row
            cell.btnViewDetails.addTarget(self, action: #selector(btnViewDetailsAction), for: UIControl.Event.touchUpInside)
        }
        return cell
    }
}
