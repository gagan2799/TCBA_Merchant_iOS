//
//  TMPaySuccessPopUpVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 30/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMPaySuccessPopUpVC: UIViewController {
    //MARK: Outlets & Variables
    var completionHandler   : ((_ amount : String) -> Void)!
    var strTransactionID    = String()
    var strCustomer         = String()
    var strPurchaseAmount   = ""
    
    //UIView
    @IBOutlet weak var viewBack: UIControl!
    @IBOutlet weak var viewPop: UIView!
    
    //UIButton
    @IBOutlet weak var btnConfirm: UIButton!
    //UILabel
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblPurchaseAmount: UILabel!
    //Constraints
    @IBOutlet weak var consHeightPopUp: NSLayoutConstraint!
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        popUpPropertiesUpdate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        //UIView
        viewPop.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7.0 * GConstant.Screen.HeightAspectRatio : 5.0)
        popUpPropertiesUpdate()
    }
    func popUpPropertiesUpdate() {
        
        //<--------Set PopUp properties for orientation----->
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            btnConfirm.titleLabel?.font = UIFont.applyRegular(fontSize: 12.0)
        }else{
            btnConfirm.titleLabel?.font = UIFont.applyRegular(fontSize: 15.0)
        }
        consHeightPopUp.constant        = 0.5 * UIScreen.main.bounds.height
        self.view.layoutIfNeeded()
    }
    
    //MARK: - UIButton & UIViewAction methods
    @IBAction func btnConfirmAction(_ sender: UIButton) {
        completionHandler("")
    }
    
    @IBAction func viewBackAction(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
}
extension TMPaySuccessPopUpVC : UITableViewDelegate,UITableViewDataSource {
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMPaymentSuccessCell") as! TMPaymentSuccessCell
        
//        cell.lblTitle.font          = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
//        cell.lblBal.font            = UIFont.applyOpenSansRegular(fontSize: 15.0)
//        cell.lblAvailable.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
//        cell.lblAmtPaid.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 15.0), borderColor: GConstant.AppColor.textDark, backgroundColor: .white, borderWidth: 1.0)
        
//        cell.layoutIfNeeded()
        return cell
    }
}
