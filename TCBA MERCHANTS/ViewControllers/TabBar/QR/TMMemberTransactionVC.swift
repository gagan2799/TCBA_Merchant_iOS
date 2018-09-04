//
//  TMTransactionPaymentVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 14/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TMMemberTransactionVC: UIViewController {
    
    //MARK: Modals
    var memTranData : MemberTransactionDetailsModel!
    var posData     : PostCreatePOSModel!
    

    
    //MARK: Outlets
    // UIImageView
    @IBOutlet weak var imgVUser: RoundedImage!
    // UILabels
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMemberId: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLC: UILabel!
    @IBOutlet weak var lblTP: UILabel!
    @IBOutlet weak var lblCS: UILabel!
    @IBOutlet weak var lblLCValue: UILabel!
    @IBOutlet weak var lblTPValue: UILabel!
    @IBOutlet weak var lblCSValue: UILabel!
    @IBOutlet weak var lblCBPurchase: UILabel!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    //UITextfield
    @IBOutlet weak var txtAmount: UITextField!
    //UIButton
    @IBOutlet weak var btnConfirmOutlet: UIButton!
    //ScrollView
    @IBOutlet weak var scrV: UIScrollView!
    //Constraints
    @IBOutlet weak var consMainVHeight: NSLayoutConstraint!
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard scrV != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrV.isScrollEnabled = true
        }else{
            scrV.isScrollEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtAmount.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard scrV != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrV.isScrollEnabled = true
        }else{
            scrV.isScrollEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Member Transaction"
        
        txtAmount.applyStyle(cornerRadius: nil, borderColor: GConstant.AppColor.textLight, borderWidth: 1.0,backgroundColor: GConstant.AppColor.grayBG)
        txtAmount.font                      = UIFont.applyOpenSansRegular(fontSize: 15.0)
        btnConfirmOutlet.titleLabel?.font   = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblUserName.font                    = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblMemberId.font                    = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblTitle.font                       = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblTP.font                          = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        lblLC.font                          = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        lblCS.font                          = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        lblLCValue.font                     = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblTPValue.font                     = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblCSValue.font                     = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblCBPurchase.font                  = UIFont.applyOpenSansSemiBold(fontSize: 16.0)
        lblPlaceHolder.font                 = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        guard memTranData != nil else {return}
        
        lblUserName.text                    = memTranData.firstName! + " " + memTranData.lastName!
        lblMemberId.text                    = "Member Id: \(memTranData.memberID ?? 0)"
        lblLCValue.text                     = "$\(Double(memTranData.availableLoyaltyCash ?? 0))"
        lblTPValue.text                     = "$\(Double(memTranData.totalPurchaseValue ?? 0))"
        lblCSValue.text                     = "\(memTranData.totalNumberOfMembers ?? 0)"
        
        guard let urlProfile = URL.init(string: memTranData.profileImageURL ?? "") else {return}
        imgVUser.setImageWithDownload(urlProfile, withIndicator: true)
        
        consMainVHeight.constant   = GConstant.Screen.Height * 0.9
        view.setNeedsLayout()
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnConfirmAction(_ sender: UIButton) {
        txtAmount.resignFirstResponder()
        if txtAmount.text == "" || txtAmount.text == "$0.00" {
            AlertManager.shared.showAlertTitle(title: "", message: "Please enter purchase amount")
        } else {
            guard let amount = txtAmount.text?.replacingOccurrences(of: "$", with: "") else {return}
            callPostCreatePOSApi(amount: amount)
        }
    }
    
    // MARK: - Navigation
    func pushToPaymentVC(data: PostCreatePOSModel) {
        let objPVC          = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.StorePayment) as! TMStorePaymentVC
        objPVC.posData      = data
        objPVC.typeTable    = .mix
        self.navigationController?.pushViewController(objPVC, animated: true)
    }
    
    func masterVC(data: PostCreatePOSModel) {
        guard let splitViewController   = storyboard?.instantiateViewController(withIdentifier: "SplitVC") as? UISplitViewController else { fatalError() }
        
        let nc : UINavigationController  = splitViewController.viewControllers[0] as! UINavigationController
        
        let vcm : TMSplitPaymentMasterVC  = nc.viewControllers[0] as! TMSplitPaymentMasterVC
        vcm.posData = data
        
        let vcd : TMSplitPaymentDetailVC = splitViewController.viewControllers[1] as! TMSplitPaymentDetailVC
        vcd.posData     = data
        vcd.typeTable   = .mix
        
        //Make sure pass data to Master & Details before setting preferredDisplayMode = .allVisible
        splitViewController.preferredDisplayMode = .allVisible
        
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = splitViewController
    }
    
    //MARK: Web Api's
    func callPostCreatePOSApi(amount:String) {
        /*
         =====================API CALL=====================
         APIName    : PostCreatePOS
         Url        : "/Payment/POS/PostCreatePOS"
         Method     : POST
         Parameters : { staffId      : 0,
         keyChainCode : 19,
         totalAmount  : 3.65, // minimum Amount should be $3
         memberID     : 19,
         storeID      : 283
         }
         ===================================================
         */
        let request             = RequestModal.mCreatePOS()
        guard let storeId       = GConstant.UserData.stores else{return}
        guard let memberId      = memTranData.memberID else {return}
        
        request.keyChainCode    = "\(memberId)"
        request.memberId        = memberId
        request.storeId         = storeId
        request.staffId         = 0
        request.totalAmount     = amount
        
        ApiManager.shared.POSTWithBearerAuth(strURL: GAPIConstant.Url.PostCreatePOS, parameter: request.toDictionary(),debugInfo: true) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                print("statusCode = 200")
                self.txtAmount.text = ""
                guard data != nil else{return}
                if let pData = try? PostCreatePOSModel.decode(_data: data!) {
                    self.posData    = pData
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        self.masterVC(data: self.posData)
                    }else {
                        self.pushToPaymentVC(data: self.posData)
                    }
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data{
                        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else {
                            let str = String(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
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
}

extension TMMemberTransactionVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if newLength > 11 { return false }
        
        let compSepByCharInSet  = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
        let strFiltered         = compSepByCharInSet.joined(separator: "")
        
        if string == strFiltered {
            let nsStr           = textField.text as NSString? ?? ""
            var str             = nsStr.replacingCharacters(in: range, with: string).replacingOccurrences(of: ".", with: "")
            str                 = str.replacingOccurrences(of: "$", with: "")
            let range: NSRange  = (str as NSString).range(of: "^0*", options: .regularExpression)
            str                 = (str as NSString).replacingCharacters(in: range, with: "")
            
            if str.count == 0 {
                str             = "$0.00"
            } else if str.count == 1 {
                str             = "$0.0" + str
            }
            else if str.count == 2 {
                str             = "$0." + str
            }else{
                str.insert(".", at: str.index(str.endIndex, offsetBy: -2))
            }
            txtAmount.text      = str.contains("$") ? str : "$" + str
        }
        return false
    }
}
