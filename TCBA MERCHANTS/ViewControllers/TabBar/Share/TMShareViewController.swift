//
//  TMShareViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMShareViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var imVLogo: UIImageView!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblStoreID: UILabel!
    @IBOutlet weak var lblShareWith: UILabel!
    @IBOutlet weak var lblYourShop: UILabel!
    @IBOutlet weak var scrShare: UIScrollView!
    
    @IBOutlet weak var btnShare: UIButton!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            guard self.scrShare != nil else {return}
            if UIDevice.current.orientation.isLandscape == true {
                self.scrShare.isScrollEnabled = true
            }else{
                self.scrShare.isScrollEnabled = false
            }
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
        if let storeId = GConstant.UserData.stores {
            lblStoreID.text       = "Store id: \(storeId)"
        }
        
        lblStoreID.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 16.0), labelColor: GConstant.AppColor.blue, cornerRadius: nil, borderColor: GConstant.AppColor.blue, borderWidth: 1.0, labelShadow: nil)
        lblCashBack.font                = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
        lblShareWith.font               = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
        lblYourShop.font                = UIFont.applyOpenSansRegular(fontSize: 16.0)
        btnShare.titleLabel?.font       = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
    }

    // MARK: - UIButton Methods
    @IBAction func btnShareAction(_ sender: UIButton) {
        callGetShareAPI()
    }
    
    // MARK: - UIActivity Controller
    func share(text: String){
        guard let userId = GConstant.UserData.userID else{return}
        let shareContent = [text,GAPIConstant.Url.kShareUrl + "\(userId)"]
        let vc = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
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
                        code : sms }
         ===================================================
         */
        let requestModel        = RequestModal.mUserData()
        requestModel.type       = "merchant"
        requestModel.code       = "sms"
        
        ApiManager.shared.GET(strURL: GAPIConstant.Url.GetShareContent, parameter: requestModel.toDictionary(), withLoader: false, debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else {return}
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
                guard let strDescription = json!["content"] else {return}
                self.share(text: strDescription)
            }else{
                AlertManager.shared.showAlertTitle(title: "Error" ,message: GConstant.Message.kSomthingWrongMessage)
            }
        }
    }
}
