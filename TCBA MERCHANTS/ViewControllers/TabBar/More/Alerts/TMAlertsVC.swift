//
//  TMAlertsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 05/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAlertsVC: UIViewController {
    //MARK: Variables & Constants
    var modelAlerts: AlertNotificationsModel!
    //MARK: Outlets
    //UITableView
    @IBOutlet weak var tblAlerts: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if modelAlerts == nil {
            callGetNotificationsApi()
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
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Alerts"
    }
    
    //MARK: - Web Api's
    func callGetNotificationsApi() {
        /*
         =====================API CALL=====================
         APIName    : GetNotifications
         Url        : "/Notification/GetNotifications"
         Method     : GET
         Parameters : nil
         ==================================================
         */
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetNotifications, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let dataAlerts    = data else { return }
                self.modelAlerts        = try? AlertNotificationsModel.decode(_data: dataAlerts)
                self.tblAlerts.reloadData()
            }else{
                if let data = data {
                    guard let json  = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str     = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
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
extension TMAlertsVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelAlerts?.notifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell") as! TMAlertCell
        
        cell.lblTitle.font  = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblDate.font   = UIFont.applyOpenSansRegular(fontSize: 14.0)
        
        cell.lblTitle.text  = modelAlerts?.notifications?[indexPath.row].title
        let date = Date().dateToDDMMYYYY(date: modelAlerts?.notifications?[indexPath.row].dateCreated ?? "")
        cell.lblDate.text   = date
        guard let imgURL    = modelAlerts.notifications?[indexPath.row].image else { return cell }
        guard let url       = URL(string: imgURL) else { return cell }
        cell.imgV.setImageWithDownload(url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objAlertDetail      = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.AlertsDetails) as! TMAlertsDetailVC
        objAlertDetail.objAlert = modelAlerts?.notifications?[indexPath.row]
        self.navigationController?.pushViewController(objAlertDetail, animated: true)
    }
}
