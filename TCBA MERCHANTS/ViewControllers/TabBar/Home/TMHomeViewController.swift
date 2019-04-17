//
//  TMHomeViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 18/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHomeViewController: UIViewController {
    
    var arryObjects = ["Groceries and Alcohol",
                       "Petrol, Tyres and service",
                       "Telephone, Internet, Power and Gas",
                       "Finance, Insurance, Travel and Accommodation",
                       "Dining and Entertainment",
                       "Hair and Beauty",
                       "General Merchandise",
                       "...and more!" ]
    //MARK: - Outlets
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var consHeightHomeIV: NSLayoutConstraint!
    @IBOutlet weak var consHeightHomeTableV: NSLayoutConstraint!
    @IBOutlet weak var scrollVHome: UIScrollView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        print("Status Bar Height:- \(String(describing: UIApplication.shared.statusBarView?.bounds.height))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard scrollVHome != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrollVHome.isScrollEnabled = true
        }else{
            scrollVHome.isScrollEnabled = false
        }
        
        if GFunction.shared.getUserDetailsFromDefaults() == nil {
            callGetUserDetailsApi()
        }else{
            GConstant.UserDetails = GFunction.shared.getUserDetailsFromDefaults()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        guard scrollVHome != nil else {return}
        scrollVHome.isScrollEnabled = UIDevice.current.orientation.isLandscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title           = "The Cash Back App"
        
        // hide the default back buttons
        self.navigationItem.hidesBackButton = true
        
        //dynamic height image & table
        if UIDevice.current.userInterfaceIdiom == .pad {
            consHeightHomeIV.constant       = GConstant.Screen.Height * 0.35
            consHeightHomeTableV.constant   = GConstant.Screen.Height * 0.55
        }else{
            consHeightHomeIV.constant       = GConstant.Screen.Height * 0.3
            consHeightHomeTableV.constant   = GConstant.Screen.Height * 0.7
        }
        self.view.layoutIfNeeded()
        // lbl properties set
        lblStoreId.applyStyle(labelFont: nil, labelColor: .white, cornerRadius: nil, borderColor: .white, borderWidth: 1.0)
        lblStoreId.backgroundColor          = UIColor.black.withAlphaComponent(0.4)
        lblStoreId.text                     = "Store ID:\(GConstant.UserData.stores ?? "")"
    }
    
    //MARK: - Web Api's
    func callGetUserDetailsApi() {
        /*
         =====================API CALL=====================
         APIName    : GetUserDetails
         Url        : "/Users/GetUserDetails"
         Method     : GET
         Parameters : nil
         ===================================================
         */

        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetUserDetails, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                GFunction.shared.saveUserDetailsInDefaults(data)
                GConstant.UserDetails = GFunction.shared.getUserDetailsFromDefaults()
            }else{
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
}

extension TMHomeViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryObjects.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! TMHomeTableViewCell
        
        if (arryObjects.count - 1 == indexPath.row) {
            cell.imgLogo.image              = nil
            cell.lblText.text               = arryObjects[indexPath.row]
            cell.lblText.applyStyle(labelFont:UIFont.applyOpenSansRegular(fontSize: 15.0) , labelColor: GConstant.AppColor.blue)
        }else{
            cell.imgLogo.image              = #imageLiteral(resourceName: "logo-icon.png")
            cell.lblText.text               = arryObjects[indexPath.row]
            cell.lblText.applyStyle(labelFont:UIFont.applyOpenSansRegular(fontSize: 15.0) , labelColor: GConstant.AppColor.black)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width:self.view.bounds.width, height: 50 * GConstant.Screen.HeightAspectRatio))
        lblTitle.applyStyle(labelFont:UIFont.applyBlocSSiBold(fontSize: 20) , labelColor: GConstant.AppColor.blue)
        lblTitle.text = " Get Cash Back on:"
        return lblTitle
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40 * GConstant.Screen.HeightAspectRatio))
        lblTitle.applyStyle(labelFont:UIFont.applyOpenSansBold(fontSize: 15) , labelColor: GConstant.AppColor.textDark)
        lblTitle.textAlignment              = .center
        lblTitle.backgroundColor            = GConstant.AppColor.grayBG
        lblTitle.text                       = "SHOP.SAVE.SIMPLE"
        return lblTitle
    }
}
