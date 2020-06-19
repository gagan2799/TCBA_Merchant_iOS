//
//  TMShareViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMShareViewController: UIViewController{
    //MARK: Outlets
    @IBOutlet weak var imVLogo: UIImageView!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblStoreID: UILabel!
    @IBOutlet weak var lblShareWith: UILabel!
    @IBOutlet weak var lblYourShop: UILabel!
    @IBOutlet weak var scrShare: UIScrollView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewLock: UIView!
    @IBOutlet weak var consStackVHeight: NSLayoutConstraint!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.EnableStaffMode) == true && UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.isStaffLoggedIn) == false{
            DispatchQueue.main.async {
                self.viewLock.isHidden  = false
            }
        } else {
            DispatchQueue.main.async {
                self.viewLock.isHidden  = true
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
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
//            guard self.scrShare != nil else {return}
//            if UIDevice.current.orientation.isLandscape == true {
//                self.scrShare.isScrollEnabled = true
//            }else{
//                self.scrShare.isScrollEnabled = false
//            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.isNavigationBarHidden = true
        if let storeId = GConstant.UserData?.stores {
            lblStoreID.text         = "Store ID: \(storeId)"
        }
        consStackVHeight.constant   = UIDevice.current.userInterfaceIdiom == .pad ? GConstant.Screen.Height * 0.2 : GConstant.Screen.iPhoneXSeries ? GConstant.Screen.Height * 0.18  : GConstant.Screen.Height * 0.15
        
        lblStoreID.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 16.0), labelColor: GConstant.AppColor.blue, borderColor: GConstant.AppColor.blue, borderWidth: 1.0)
        lblCashBack.font                = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
        lblShareWith.font               = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
        lblYourShop.font                = UIFont.applyOpenSansRegular(fontSize: 16.0)
        btnShare.titleLabel?.font       = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
    }

    // MARK: - UIButton Methods
    @IBAction func btnShareAction(_ sender: UIButton) {
        callGetShareAPI()
    }
    
    @IBAction func btnLocklogin(_ sender: UIButton) {
        staffLoginVC()
    }
    
    // MARK: - UIActivity Controller
    func share(text: String) {
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad{
            vc.popoverPresentationController?.sourceView = self.btnShare
            vc.popoverPresentationController?.sourceRect = self.btnShare.bounds
        }
        present(vc, animated: true)
    }
    
    // MARK: - Web Api's
    func callGetShareAPI() {
        /*
         =====================API CALL=====================
         APIName    : GetShareContent
         Url        : "/Users/GetForgotUsername"
         Method     : GET
         Parameters : { type : merchant,
                        code : email }
         ===================================================
         */
        let requestModel        = RequestModal.mUserData()
        guard let storeId       = GConstant.UserData?.stores else{return}
        requestModel.storeID    = storeId
        requestModel.code       = "email"
        
        ApiManager.shared.GET(strURL: GAPIConstant.Url.GetShareContent, parameter: requestModel.toDictionary(), withLoader: true, debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else {return}
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??)
                guard let strDescription = json??["content"] as? String else {return}
                guard let strLink        = json??["shareLink"] as? String else {return}
                self.share(text: strDescription + " " + strLink)
            }else{
                AlertManager.shared.showAlertTitle(title: "Error" ,message: GConstant.Message.kSomthingWrongMessage)
            }
        }
    }
    
    //MARK: CheckStaffLogin Method & Api
    func staffLoginVC() {
        let obj                     = storyboard?.instantiateViewController(withIdentifier: "TMStaffLoginVC") as! TMStaffLoginVC
        obj.userT                   = .staff
        obj.modalPresentationStyle  = .overCurrentContext
        obj.completionHandler       = { (pin) in
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
        let request         = RequestModal.mCreatePOS()
        guard let storeId   = GConstant.UserData?.stores else{return}
        request.storeId     = storeId
        request.pinCode     = pin
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStaffLogin, parameter: request.toDictionary(), withLoader : false) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("Correct PIN")
                DispatchQueue.main.async {
                    self.viewLock.isHidden  = true
                    UserDefaults.standard.set(true, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
                    UserDefaults.standard.synchronize()
                }
            }else{
                AlertManager.shared.showAlertTitle(title: "Incorrect PIN" ,message:"Your pin is incorrect, please try again.")
            }
        }
    }
}

//extension TMShareViewController: UIActivityItemSource {
//    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
//      return ""
//    }
//
//    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//        if activityType == .postToTwitter {
//            return ""
//        } else if activityType == .postToFacebook {
//            return ""
//        } else if activityType == .message {
//            return ""
//        } else {
//            return ""
//        }
//    }
//}
