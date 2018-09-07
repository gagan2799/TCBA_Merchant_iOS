//
//  TMTradingHoursVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMTradingHoursVC: UIViewController {
    
    enum TradingType {
        case trading
        case split
        case join
    }
    
    var typeCell : TradingType!
    
    //MARK: - Outlets
    @IBOutlet weak var tblTrading: UITableView!
    //MARK: Variables & Constents
    let arrDays                 = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var shift                   = TradingHourShift.init(startTime: "", endTime: "")
    var tradingData             : TradingHourModel!
    let footerHeight:CGFloat    = 80
    
    
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
    
    //MARK: UITableView Cell Methods
    func tradingCell(withTable tableView: UITableView,cellForRowAt indexPath: IndexPath, daysData arrDay: [TradingHourDay]? ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMTradingCell") as! TMTradingCell
        
        cell.lblDays.font   = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        cell.lblInfo.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        if arrDay != nil {
            guard let day       = arrDay![indexPath.row].day else { return cell }
            cell.lblDays.text   = String(day.prefix(3))
            
            guard let status    = arrDay![indexPath.row].status else { return cell }
            cell.lblInfo.text   = status
        } else {
            cell.lblDays.text   = arrDays[indexPath.row]
        }
        return cell
    }
    
    func splitCell(withTable tableView: UITableView,cellForRowAt indexPath: IndexPath, daysData arrDay: [TradingHourDay]?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingSplitCell") as! TMTradingSplitCell
        cell.lblDay.font   = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        
        cell.lblStart.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.lblEnd.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        if arrDay != nil {
            guard let day       = arrDay![indexPath.row].day else { return cell }
            cell.lblDay.text    = String(day.prefix(3))
            
            guard let time      = arrDay![indexPath.row].shifts else { return cell }
            cell.lblStart.text  = convertTimeToAmPm(timeString: time.first?.startTime)
            cell.lblEnd.text    = convertTimeToAmPm(timeString: time.first?.endTime)
        } else {
            cell.lblDay.text    = arrDays[indexPath.row]
            cell.lblStart.text  = ""
            cell.lblEnd.text    = ""
        }
        
        
        cell.btnSplit.tag   = indexPath.row
        cell.btnSplit.applyStyle(titleLabelFont: UIFont.applyOpenSansSemiBold(fontSize: 15.0), cornerRadius: 4, state: .normal)
        cell.btnSplit.addTarget(self, action: #selector(btnSplit(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func joinCell(withTable tableView: UITableView,cellForRowAt indexPath: IndexPath, daysData arrDay: [TradingHourDay]?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingJoinCell") as! TMTradingJoinCell
        cell.lblDay.font    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        cell.lblStart.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.lblStart1.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.lblEnd.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.lblEnd1.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        if arrDay != nil {
            guard let day       = arrDay![indexPath.row].day else { return cell }
            cell.lblDay.text    = String(day.prefix(3))
            guard let time      = arrDay![indexPath.row].shifts else { return cell }
            cell.lblStart.text  = convertTimeToAmPm(timeString: time.first?.startTime)
            cell.lblEnd.text    = convertTimeToAmPm(timeString: time.first?.endTime)
            cell.lblStart1.text = convertTimeToAmPm(timeString: time.last?.startTime)
            cell.lblEnd1.text   = convertTimeToAmPm(timeString: time.last?.endTime)
        }else{
            cell.lblDay.text    = arrDays[indexPath.row]
            cell.lblStart.text  = ""
            cell.lblEnd.text    = ""
            cell.lblStart1.text = ""
            cell.lblEnd1.text   = ""
        }
        
        cell.btnJoin.tag    = indexPath.row
        cell.btnJoin.applyStyle(titleLabelFont: UIFont.applyOpenSansSemiBold(fontSize: 15.0), cornerRadius: 4, state: .normal)
        cell.btnJoin.addTarget(self, action: #selector(btnJoin(sender:)), for: .touchUpInside)
        
        return cell
    }
    //MARK: - UIButton Action Methods
    @objc func btnSave(sender: UIButton) {
        print("save tapped")
    }
    
    @objc func btnSplit(sender: UIButton) {
        print("spit tapped index: \(sender.tag)")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if (tradingData) != nil {
            if let arrDay = tradingData.days {
                if (arrDay[indexPath.row].shifts != nil) {
                    if let count = arrDay[indexPath.row].shifts?.count {
                        if count <= 1 {
                            tradingData.days![indexPath.row].shifts?.append(shift)
                        }
                    }
                }
            }
        }
        
        tblTrading.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func btnJoin(sender: UIButton) {
        print("join tapped index: \(sender.tag)")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if (tradingData) != nil {
            if let arrDay = tradingData.days {
                if (arrDay[indexPath.row].shifts != nil) {
                    if let count = arrDay[indexPath.row].shifts?.count {
                        if count > 1 {
                            tradingData.days![indexPath.row].shifts?.remove(at: 1)
                        }
                    }
                }
            }
        }
        
        tblTrading.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: - Coustom Methods
    func convertTimeToAmPm(timeString time: String?) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "HH:mm:ss"
        
        guard let date = dF.date(from: time!) else { return  time! }
        dF.dateFormat = "h:mm a"
        return dF.string(from: date)
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
        guard tradingData != nil else { return arrDays.count }
        return tradingData.days?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tradingData != nil else { return 60 * GConstant.Screen.HeightAspectRatio }
        if let arrDay = tradingData.days {
            if (arrDay[indexPath.row].shifts != nil) {
                if let count = arrDay[indexPath.row].shifts?.count {
                    if count >= 2 {
                        return 120 * GConstant.Screen.HeightAspectRatio
                    }
                }
            }
        }
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tradingData) != nil {
            if let arrDay = tradingData.days {
                if (arrDay[indexPath.row].shifts != nil) {
                    if let count = arrDay[indexPath.row].shifts?.count {
                        if count <= 1 {
                            return splitCell(withTable: tableView, cellForRowAt: indexPath, daysData: arrDay)
                        } else {
                            return joinCell(withTable: tableView, cellForRowAt: indexPath, daysData: arrDay)
                        }
                    }
                }else{
                    return tradingCell(withTable: tableView, cellForRowAt: indexPath, daysData: arrDay)
                }
            }
        }
        if typeCell == .trading {
            return tradingCell(withTable: tableView, cellForRowAt: indexPath, daysData: nil)
        } else if typeCell == .join {
            return joinCell(withTable: tableView, cellForRowAt: indexPath, daysData: nil)
        } else {
            return splitCell(withTable: tableView, cellForRowAt: indexPath, daysData: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard tradingData != nil else { return footerHeight * GConstant.Screen.HeightAspectRatio }
        return footerHeight * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
