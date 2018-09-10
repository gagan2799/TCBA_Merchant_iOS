//
//  TMTradingHoursVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import Alamofire
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
    var shift                   = TradingHourShift.init(startTime: "", endTime: "")
    var tradingData             : TradingHourModel!
    let footerHeight:CGFloat    = 80
    

    
    //MARK: - TapGestures
    //    For split and Join cell
    let tapLblStart     = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
    let tapLblEnd       = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
    //    For join cell
    let tapLblStart1    = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
    let tapLblEnd1      = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callGetTradingHoursApi()
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
        
        //<====This function will work if trading data will be nil====>
        emptyTradingData()
    }
    
    
    
    //MARK: UITableView Cell Methods
    func tradingCell(withTable tableView: UITableView,cellForRowAt indexPath: IndexPath, daysData arrDay: [TradingHourDay]? ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMTradingCell") as! TMTradingCell
        
        cell.lblDays.font   = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        cell.lblInfo.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        guard let day       = arrDay![indexPath.row].day else { return cell }
        cell.lblDays.text   = String(day.prefix(3))
        
        guard let status    = arrDay![indexPath.row].status else { return cell }
        cell.lblInfo.text   = status
        cell.lblInfo.tag    = indexPath.row
        
        let tapLblInfo      = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        cell.lblInfo.addGestureRecognizer(tapLblInfo)
        
        return cell
    }
    
    func splitCell(withTable tableView: UITableView,cellForRowAt indexPath: IndexPath, daysData arrDay: [TradingHourDay]?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradingSplitCell") as! TMTradingSplitCell
        cell.lblDay.font   = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        
        cell.lblStart.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.lblEnd.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: GConstant.AppColor.textLight, cornerRadius: 4.0, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        guard let day       = arrDay![indexPath.row].day else { return cell }
        cell.lblDay.text    = String(day.prefix(3))
        
        guard let time      = arrDay![indexPath.row].shifts else { return cell }
        cell.lblStart.text  = convertTimeToAmPm(timeString: time.first?.startTime)
        cell.lblEnd.text    = convertTimeToAmPm(timeString: time.first?.endTime)
        
        let tapLblStart     = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        let tapLblEnd       = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        
        cell.lblStart.tag   = indexPath.row
        cell.lblEnd.tag     = 10 + indexPath.row
        
        cell.lblStart.addGestureRecognizer(tapLblStart)
        cell.lblEnd.addGestureRecognizer(tapLblEnd)
        
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
        
        
        guard let day       = arrDay![indexPath.row].day else { return cell }
        cell.lblDay.text    = String(day.prefix(3))
        guard let time      = arrDay![indexPath.row].shifts else { return cell }
        cell.lblStart.text  = convertTimeToAmPm(timeString: time.first?.startTime)
        cell.lblEnd.text    = convertTimeToAmPm(timeString: time.first?.endTime)
        cell.lblStart1.text = convertTimeToAmPm(timeString: time.last?.startTime)
        cell.lblEnd1.text   = convertTimeToAmPm(timeString: time.last?.endTime)
        
        let tapJLblStart     = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        let tapJLblEnd       = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        let tapJLblStart1    = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        let tapJLblEnd1      = UITapGestureRecognizer(target: self, action: #selector(TMTradingHoursVC.tapFunction))
        
        cell.lblStart.tag   = indexPath.row
        cell.lblEnd.tag     = 10 + indexPath.row
        cell.lblStart1.tag  = 20 + indexPath.row
        cell.lblEnd1.tag    = 30 + indexPath.row
        
        cell.lblStart.addGestureRecognizer(tapJLblStart)
        cell.lblEnd.addGestureRecognizer(tapJLblEnd)
        cell.lblStart1.addGestureRecognizer(tapJLblStart1)
        cell.lblEnd1.addGestureRecognizer(tapJLblEnd1)
        
        cell.btnJoin.tag    = indexPath.row
        cell.btnJoin.applyStyle(titleLabelFont: UIFont.applyOpenSansSemiBold(fontSize: 15.0), cornerRadius: 4, state: .normal)
        cell.btnJoin.addTarget(self, action: #selector(btnJoin(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    //MARK: - UITapGesture
    @objc func tapFunction(sender:UITapGestureRecognizer) {
    
        var tag     = sender.view?.tag ?? 0
        var index   = sender.view?.tag ?? 0
        if index < 10 {
        } else if index < 20 {
            index -= 10
        } else if tag < 30 {
            index -= 20
        } else {
            index -= 30
        }
        
        let obj     = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.DatePicker) as! TMDatePickerVC
        obj.completionHandler   = { (dateString) in
            if dateString != "" {
                print(tag)
                let indexPath = IndexPath(row: index, section: 0)
                if (self.tradingData) != nil {
                    if let arrDay = self.tradingData.days {
                        if dateString == "closed" || dateString == "byAppointment" {
                            self.tradingData.days![indexPath.row].status = dateString
                            if self.tradingData.days![indexPath.row].shifts != nil {
                               self.tradingData.days![indexPath.row].shifts = nil
                            }
                        } else {
                            if (arrDay[indexPath.row].shifts != nil) {
                                if tag < 10 {
                                    self.tradingData.days![indexPath.row].shifts![0].startTime = dateString
                                } else if tag < 20 {
                                    tag -= 10
                                    self.tradingData.days![indexPath.row].shifts![0].endTime = dateString
                                    
                                } else if tag < 30 {
                                    tag -= 20
                                    self.tradingData.days![indexPath.row].shifts![1].startTime = dateString
                                } else {
                                    tag -= 30
                                    self.tradingData.days![indexPath.row].shifts![1].endTime = dateString
                                }
                            }else{
                                self.tradingData.days![indexPath.row].shifts = [TradingHourShift.init(startTime: dateString, endTime: "")]
                            }
                        }
                    }
                }
                self.tblTrading.reloadRows(at: [indexPath], with: .none)
                print(dateString)
            }
        }
        
        obj.modalPresentationStyle  = .overCurrentContext
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    //MARK: - UIButton Action Methods
    @objc func btnSave(sender: UIButton) {
        print("save tapped")
        if (tradingData) != nil {
            if let arrDay = tradingData.days {
                for day in arrDay{
                    if let shifts = day.shifts{
                        for shi in shifts{
                            if shi.startTime == "" || shi.endTime == "" {
                                AlertManager.shared.showAlertTitle(title: "" ,message:"Please enter a valid time")
                                return
                            }
                        }
                    }
                }
            }
        }
        callPutUpdateTradingHoursApi()
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
    func emptyTradingData() {
        if tradingData == nil {
            let days = TradingHourModel.init(days: [
                TradingHourDay.init(status: "open", day: "Monday", shifts: [TradingHourShift.init(startTime: "", endTime: "")]),
                TradingHourDay.init(status: "open", day: "Tuesday", shifts: [TradingHourShift.init(startTime: "", endTime: "")]),
                TradingHourDay.init(status: "open", day: "Wednesday", shifts: [TradingHourShift.init(startTime: "", endTime: "")]),
                TradingHourDay.init(status: "open", day: "Thursday", shifts: [TradingHourShift.init(startTime: "", endTime: "")]),
                TradingHourDay.init(status: "open", day: "Friday", shifts: [TradingHourShift.init(startTime: "", endTime: "")]),
                TradingHourDay.init(status: "open", day: "Saturday", shifts: [TradingHourShift.init(startTime: "", endTime: "")]),
                TradingHourDay.init(status: "open", day: "Sunday", shifts: [TradingHourShift.init(startTime: "", endTime: "")])])
            tradingData = days
            tblTrading.reloadData()
        }
    }
    
    func convertTimeToAmPm(timeString time: String?) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "HH:mm:ss"
        
        guard let date = dF.date(from: time!) else { return  time! }
        dF.dateFormat = "h:mm a"
        return dF.string(from: date)
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    func convertToDictionary(text: String) -> [Dictionary<String,Any>]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
    
    func callPutUpdateTradingHoursApi() {
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
        
        let abc = try! tradingData.days.encode()
        
        let request = RequestModal.mUpdateStoreContent()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeId     = storeId
        request.days        = abc
//        let url             = GAPIConstant.Url.PutUpdateTradingHours + "?\(storeId)"
        ApiManager.shared.PUTWithBearerAuth(strURL: GAPIConstant.Url.PutUpdateTradingHours, parameter: request.toDictionary(), encording: URLEncoding()) { (data : Data?, statusCode : Int?, error: String) in
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
        tableView.becomeFirstResponder()
    }
}
