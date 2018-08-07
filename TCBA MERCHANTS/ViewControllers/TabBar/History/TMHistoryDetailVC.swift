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
    
    var type : types!
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .all {
            
        }else if type == .today{
            
        }else if type == .incomplete{
            
        }else if type == .outstanding{
            
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
    }
    
    //MARK: - Web Api's
    func callTransactionDetailsApi() {
        /*
         =====================API CALL=====================
         APIName    : TransactionData
         Url        : "/Merchant/GetMerchantTransactionSummary"
         Method     : GET
         Parameters : { storeID : "",
         type    : ""
         }
         ===================================================
         */
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.HistoryTransactionDetails, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                
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
            
        }else if type == .today{
            
        }else if type == .incomplete{
            
        }else if type == .outstanding{
          
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  height     = 45 * GConstant.Screen.HeightAspectRatio
        
        let viewHeader  = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: height))
        viewHeader.backgroundColor = GConstant.AppColor.grayBG
        
        let view1       = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width*0.3, height: height))
        view1.backgroundColor = GConstant.AppColor.textDark
        let lblDateID = UILabel.init(frame: CGRect(x: 10, y: 0, width: (self.view.bounds.size.width*0.3)-20, height: height))
        lblDateID.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 16.0), labelColor: .white, backgroundColor: GConstant.AppColor.textDark)
        view1.addSubview(lblDateID)
        
        let view2       = UIView.init(frame: CGRect(x: view1.bounds.maxX+1, y: 0, width: GConstant.Screen.Width*0.4, height: height))
        view2.backgroundColor = GConstant.AppColor.textDark
        let lblMember = UILabel.init(frame: CGRect(x: 10, y: 0, width: (self.view.bounds.size.width*0.4)-20, height: height))
        lblMember.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 16.0), labelColor: .white, backgroundColor: GConstant.AppColor.textDark)
        view2.addSubview(lblMember)
        
        let view3       = UIView.init(frame: CGRect(x:view1.bounds.maxX+1 + view2.bounds.size.width + 1, y: 0, width: (GConstant.Screen.Width*0.3)-2, height: height))
        view3.backgroundColor = GConstant.AppColor.textDark
        let lblPrice = UILabel.init(frame: CGRect(x: 10, y: 0, width: (self.view.bounds.size.width*0.3)-22, height: height))
        lblPrice.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 16.0), labelColor: .white, backgroundColor: GConstant.AppColor.textDark)
        view3.addSubview(lblPrice)
        
        switch type {
        case .all:
            lblDateID.text  = "Date"
            lblMember.text  = "Member"
            lblPrice.text   = "$"
            break
        case .today:
            lblDateID.text  = "Date"
            lblMember.text  = "Member"
            lblPrice.text   = "$"
            break
        case .incomplete:
            lblDateID.text  = "Member ID"
            lblMember.text  = "Member"
            lblPrice.text   = "$"
            break
        case .outstanding:
            lblDateID.text  = "id"
            lblMember.text  = "Member"
            lblPrice.text   = "Loyalty"
            break
        default:
            lblDateID.text  = "Date"
            lblMember.text  = "Member"
            lblPrice.text   = "$"
        }
        
        viewHeader.addSubview(view1)
        viewHeader.addSubview(view2)
        viewHeader.addSubview(view3)
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCellDetails") as! TMHistoryDetailTableCell
        
        cell.lblDateOrID.font    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        cell.lblMember.font      = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        cell.lblPrice.font       = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        
        switch type {
        case .all:
            cell.lblDateOrID.text       = "Date"
            cell.lblMember.text         = "Member"
            cell.lblPrice.text          = "$"
            break
        case .today:
            cell.lblDateOrID.text       = "Date"
            cell.lblMember.text         = "Member"
            cell.lblPrice.text          = "$"
            break
        case .incomplete:
            cell.lblDateOrID.text       = "Date"
            cell.lblMember.text         = "Member"
            cell.lblPrice.text          = "$"
            break
        case .outstanding:
            cell.lblDateOrID.text       = "Date"
            cell.lblMember.text         = "Member"
            cell.lblPrice.text          = "$"
            break
        default: break
            
        }
        
        return cell
    }
}
