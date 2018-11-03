//
//  TMMoreViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 31/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMoreViewController: UIViewController {
    //MARK: Variables & Constants
    let arrCellNames    = ["My Business", "My Staff Accounts", "Videos", "Alerts", "Calculator", "About Us", "Rate this App", "Contact Us"]
    let arrICellIcons   = ["more_business", "more_staff", "videos_Icon", "alerts_Icon", "calculator_Icon", "about_Icon", "feedback_Icon", "contact_us"]
    
    //MARK: Outlets
    //UILabel
    @IBOutlet weak var lblVersion: UILabel!
    //UITableView
    @IBOutlet weak var tblMore: UITableView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.isStaffLoggedIn) == true {
            navigationItem.leftBarButtonItem    = UIBarButtonItem(title: "Logout Staff", style: .done, target: self, action: #selector(logoutStaffAction))
        } else {
            self.navigationItem.leftBarButtonItem = nil
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
        self.navigationItem.title   = "More"
        lblVersion.font             = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text         = "Version \(version)"
        }
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        AlertManager.shared.showAlertTitle(title: "Logout", message: "Are you sure you want to logout?", buttonsArray: ["Cancel","Logout"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                GFunction.shared.userLogOut()
                break
            default:
                break
            }
        }
    }
    //MARK: - BarButton Action Methods
    @objc func logoutStaffAction(sender: UIBarButtonItem){
        self.navigationItem.leftBarButtonItem = nil
        UserDefaults.standard.set(false, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
        UserDefaults.standard.synchronize()
    }
    // MARK: - Navigation
    func staffLoginVC() {
        let obj = storyboard?.instantiateViewController(withIdentifier: "TMStaffLoginVC") as! TMStaffLoginVC
        obj.userT = .merchant
        obj.modalPresentationStyle = .overCurrentContext
        obj.completionHandler   = { (password) in
            self.callPostCheckPasswordApi(password: password)
        }
        rootWindow().rootViewController?.present(obj, animated: true, completion: nil)
    }
    func toSplitVC() {
        guard let splitViewController   = storyboard?.instantiateViewController(withIdentifier: "StaffSplitVC") as? UISplitViewController else { fatalError() }
        
        let nc : UINavigationController  = splitViewController.viewControllers[0] as! UINavigationController
        
        let _ : TMMyStaffAccountMasterVC  = nc.viewControllers[0] as! TMMyStaffAccountMasterVC
        
        let _ : TMMyStaffAccountDetailsVC = splitViewController.viewControllers[1] as! TMMyStaffAccountDetailsVC
        
        //Make sure pass data to Master & Details before setting preferredDisplayMode = .allVisible
        splitViewController.preferredDisplayMode = .allVisible
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = splitViewController
        nc.popToRootViewController(animated: false)
        
    }
    
    //Mark: - Web Api's
    func callPostCheckPasswordApi(password: String) {
        /*
         =====================API CALL=====================
         APIName    : PostCheckPassword
         Url        : "/Users/PostCheckPassword"
         Method     : POST
         Parameters : { password   : "" }
         ===================================================
         */
        let request             = RequestModal.mUserData()
        request.password        = password
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostCheckPassword, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let mData = data else{return}
                let isTrue = PostCheckPasswordModel.decodeData(_data: mData).response
                if isTrue?.correctPassword == true {
                    self.toSplitVC()
                } else {
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:"Incorrect Password")
                }
                
            } else {
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                            let str = String(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
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

extension TMMoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMMoreTableCell") as! TMMoreTableCell
        cell.lblName.font   = UIFont.applyOpenSansRegular(fontSize: 16.0)
        cell.lblName.text   = arrCellNames[indexPath.row]
        cell.imgIcon.image  = UIImage(named: arrICellIcons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //MyBussiness
            let objMB = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.MyBusiness) as! TMMyBusinessVC
            self.navigationController?.pushViewController(objMB, animated: true)
        } else if indexPath.row == 1 {
            if UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.EnableStaffMode){
                staffLoginVC()
            }else{
                toSplitVC()
            }
        } else if indexPath.row == 2 {
            //Videos
            let objVID = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Video) as! TMVideoVC
            self.navigationController?.pushViewController(objVID, animated: true)
        } else if indexPath.row == 3 {
            //Alerts
            let objAl = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Alerts) as! TMAlertsVC
            self.navigationController?.pushViewController(objAl, animated: true)
        } else if indexPath.row == 4 {
            //Calculator
            let objCal = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Calculator) as! TMCalculatorVC
            self.navigationController?.pushViewController(objCal, animated: true)
        } else if indexPath.row == 5 {
            //AboutUs
            let objAU = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.AboutUs) as! TMAboutUsVC
            self.navigationController?.pushViewController(objAU, animated: true)
        } else if indexPath.row == 6 {
            //RateUs
            let objRU = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.RateUs) as! TMRateUsVC
            self.navigationController?.pushViewController(objRU, animated: true)
        } else if indexPath.row == 7 {
            //ContactUs
            let objCU = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.ContactUs) as! TMContactUsVC
            self.navigationController?.pushViewController(objCU, animated: true)
        }
    }
}
