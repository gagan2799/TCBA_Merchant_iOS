//
//  TMTradingHoursVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMTradingHoursVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tblTrading: UITableView!
    //MARK: Variables & Constents
    let arrDays         = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var tradingData     : TradingHourModel!
    let footerHeight:CGFloat   = 80
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title = "Trading Hours"
        
        callGetTradingHoursApi()
    }
    //MARK: - UIButton Action Methods
    @objc func btnSave(sender: UIButton) {
            print("save tapped")
    }
    
    //MARK: - Web Api's
    func callGetTradingHoursApi() {
        /*
         =====================API CALL=====================
         APIName    : GetTradingHours
         Url        : "/Stores/GetTradingHours"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeID     = storeId
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetTradingHours, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                if let tData = try? TradingHourModel.decode(_data: data) {
                    self.tradingData = tData
                    self.tblTrading.reloadData()
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] ?? GConstant.Message.kSomthingWrongMessage)
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
    
    func callPutUpdateTradingHoursApi(withContent content: String) {
        /*
         =====================API CALL=====================
         APIName    : PutUpdateTradingHours
         Url        : "/Stores/PutUpdateTradingHours"
         Method     : PUT
         Parameters : { TypeStore.RawValue  : "<p>Cash Back on great on offers and services direct from The Cash Back App</p>",
         storeId             : 283
         }
         ===================================================
         */
        
        let request = RequestModal.mUpdateStoreContent()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeId     = storeId
        
        ApiManager.shared.PUTWithBearerAuth(strURL: GAPIConstant.Url.PutUpdateTradingHours, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success", message: "Your updates have been saved.")
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] ?? GConstant.Message.kSomthingWrongMessage)
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
}

extension TMTradingHoursVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tradingData != nil else { return 0 }
        return tradingData.days?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMTradingCell") as! TMTradingCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingSplitCell") as! TMTradingSplitCell
        
        cell.lblDays.font   = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        cell.lblInfo.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        guard let arrDay    = tradingData.days else { return cell }
        
        guard let day       = arrDay[indexPath.row].day else { return cell }
        cell.lblDays.text   = String(day.prefix(3))
        
        guard let status    = arrDay[indexPath.row].status else { return cell }
        cell.lblInfo.text   = status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard tradingData != nil else { return 0 }
        return footerHeight * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard tradingData != nil else { return nil }
        let viewBtn = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: footerHeight * GConstant.Screen.HeightAspectRatio))
        viewBtn.backgroundColor = .white
        let btnWidth    = viewBtn.bounds.width * 0.4
        let btnHeigth   = viewBtn.bounds.height * 0.5
        let center      = CGPoint(x: viewBtn.center.x-(btnWidth/2), y: viewBtn.center.y-(btnHeigth/2))
        let btn         = UIButton.init(frame: CGRect(origin: center, size: CGSize(width: btnWidth, height: btnHeigth)))
        btn.titleLabel?.textColor   = .white
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor         = GConstant.AppColor.blue
        btn.addTarget(self, action: #selector(btnSave), for: .touchUpInside)
        
        viewBtn.addSubview(btn)
        return viewBtn
    }
}
