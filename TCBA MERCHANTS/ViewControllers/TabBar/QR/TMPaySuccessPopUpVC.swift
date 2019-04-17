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
    var posData             : PostCreatePOSModel!
    //UIView
    @IBOutlet weak var viewBack: UIControl!
    @IBOutlet weak var viewPop: UIView!
    
    //UIButton
    @IBOutlet weak var btnConfirm: UIButton!
    //UILabel
    @IBOutlet weak var lblTransaction: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var lblCus: UILabel!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblPurchase: UILabel!
    @IBOutlet weak var lblPurchaseAmount: UILabel!
    
    @IBOutlet weak var tblPopUp: UITableView!{
        didSet {
            tblPopUp.tableFooterView = UIView(frame: .zero)
        }
    }
    
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
    
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        //UIView
        viewPop.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7.0 * GConstant.Screen.HeightAspectRatio : 5.0)
        
        lblTransactionID.text           = "\(posData.transactionID ?? 0)"
        lblCustomer.text                = posData.memberFullName
        lblPurchaseAmount.text          = "$\(posData.totalPurchaseAmount ?? 0.0)"
        tblPopUp.layer.borderWidth      = 1.0
        tblPopUp.layer.borderColor      = GConstant.AppColor.textDark.cgColor
        tblPopUp.layer.masksToBounds    = true
        popUpPropertiesUpdate()
    }
    
    func popUpPropertiesUpdate() {
        //<--------Set PopUp properties for orientation----->
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            btnConfirm.titleLabel?.font = UIFont.applyRegular(fontSize: 12.0)
            lblTransaction.font         = UIFont.applyOpenSansRegular(fontSize: 12.0)
            lblTransactionID.font       = UIFont.applyOpenSansRegular(fontSize: 12.0)
            lblCus.font                 = UIFont.applyOpenSansRegular(fontSize: 12.0)
            lblCustomer.font            = UIFont.applyOpenSansRegular(fontSize: 12.0)
            lblPurchase.font            = UIFont.applyOpenSansRegular(fontSize: 12.0)
            lblPurchaseAmount.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
        }else{
            btnConfirm.titleLabel?.font = UIFont.applyRegular(fontSize: 15.0)
            lblTransaction.font         = UIFont.applyOpenSansRegular(fontSize: 14.0)
            lblTransactionID.font       = UIFont.applyOpenSansRegular(fontSize: 14.0)
            lblCus.font                 = UIFont.applyOpenSansRegular(fontSize: 14.0)
            lblCustomer.font            = UIFont.applyOpenSansRegular(fontSize: 14.0)
            lblPurchase.font            = UIFont.applyOpenSansRegular(fontSize: 14.0)
            lblPurchaseAmount.font      = UIFont.applyOpenSansRegular(fontSize: 14.0)
        }
        tblPopUp.reloadData()
        consHeightPopUp.constant        = GConstant.Screen.iPhoneXSeries ? 0.4 * UIScreen.main.bounds.height : 0.5 * UIScreen.main.bounds.height
        self.view.layoutIfNeeded()
    }
    
    //MARK: - UIButton & UIViewAction methods
    @IBAction func btnConfirmAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
        completionHandler("")
    }
    
    @IBAction func viewBackAction(_ sender: UIControl) {
        dismiss(animated: false, completion: nil)
    }
}

extension TMPaySuccessPopUpVC : UITableViewDelegate,UITableViewDataSource {
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posData.payments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentSuccessCell") as! TMPaymentSuccessCell
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            cell.lblMethod.font     = UIFont.applyOpenSansRegular(fontSize: 12.0)
            cell.lblMethodVal.font  = UIFont.applyOpenSansRegular(fontSize: 12.0)
            cell.lblAmount.font     = UIFont.applyOpenSansRegular(fontSize: 12.0)
            cell.lblAmountVal.font  = UIFont.applyOpenSansRegular(fontSize: 12.0)
        }else{
            cell.lblMethod.font     = UIFont.applyOpenSansRegular(fontSize: 14.0)
            cell.lblMethodVal.font  = UIFont.applyOpenSansRegular(fontSize: 14.0)
            cell.lblAmount.font     = UIFont.applyOpenSansRegular(fontSize: 14.0)
            cell.lblAmountVal.font  = UIFont.applyOpenSansRegular(fontSize: 14.0)
        }
        cell.lblMethodVal.text      = posData.payments?[indexPath.row].name
        cell.lblAmountVal.text      = "$\(posData.payments?[indexPath.row].amountReceivedByStore ?? 0.00)"
        
        cell.layoutIfNeeded()
        return cell
    }
}
