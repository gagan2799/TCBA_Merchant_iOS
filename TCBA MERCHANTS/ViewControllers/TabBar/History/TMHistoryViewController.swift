//
//  TMHistoryViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryViewController: UIViewController {
    //MARK: Variables
    var transactionData : TransactionDataModel!
    var incompleteData  : IncompleteTransactionDataModel!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title = "History"
        callTransactionDataApi()
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
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.TransactionData, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.transactionData = try! TransactionDataModel.decode(_data: data)
                // Calling IncompleteTransactionData Api
                let request = RequestModal.mUserData()
                guard let storeId = GConstant.UserData.stores else{return}
                request.storeID = storeId
                self.callIncompleteTransactionDataApi(request)
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
    
    func callIncompleteTransactionDataApi(_ requestModel : RequestModal.mUserData) {
        /*
         =====================API CALL=====================
         APIName    : IncompleteTransactionData
         Url        : "/Payment/POS/GetIncompletePOSes"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.IncompleteTransactionData, parameter: requestModel.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.incompleteData = try! IncompleteTransactionDataModel.decode(_data: data)
                print(self.incompleteData)
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
extension TMHistoryViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TMHomeTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width:self.view.bounds.width, height: 50 * GConstant.Screen.HeightAspectRatio))
        lblTitle.applyStyle(labelFont:UIFont.applyBlocSSiBold(fontSize: 20) , labelColor: #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7921568627, alpha: 1), cornerRadius: nil, borderColor: nil, borderWidth: nil, labelShadow: nil)
        lblTitle.text = " Get Cash Back on:"
        return lblTitle
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40 * GConstant.Screen.HeightAspectRatio))
        lblTitle.applyStyle(labelFont:UIFont.applyOpenSansBold(fontSize: 15) , labelColor: #colorLiteral(red: 0.2310000062, green: 0.2310000062, blue: 0.2310000062, alpha: 1) , cornerRadius: nil, borderColor: nil, borderWidth: nil, labelShadow: nil)
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        lblTitle.text = "SHOP.SAVE.SIMPLE"
        return lblTitle
    }
}
