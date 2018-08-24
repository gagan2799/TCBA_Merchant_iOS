//
//  TMPopUPVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 24/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMPopUPVC: UIViewController {
    //MARK: Outlets & Variables
    enum type:uint {
        case creditCard
        case other
    }
    var completionHandler   : ((_ amount : String) -> Void)!
    var typePopUp           : type!
    var method              = String()
    var strCardNumber       = String()
    var transactionAmount   = String()
    var strCCName           = ""
    var txtUserIntrection   = Bool()
    
    //UIButton
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    //UIView
    @IBOutlet weak var viewBack: UIControl!
    @IBOutlet weak var viewPop: UIView!
    @IBOutlet weak var viewCC: UIView!
    //UILabel
    @IBOutlet weak var lblTitleMethod: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    //UITextfield
    @IBOutlet weak var txtAmount: UITextField!
    //UIImageView
    @IBOutlet weak var imgV: UIImageView!
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
        popUpPropertiesUpdate(strCCName: strCCName)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        lblTitleMethod.text     = method
        txtAmount.isUserInteractionEnabled = txtUserIntrection
        txtAmount.text          = transactionAmount != "" ? "$" + transactionAmount : "$0.00"
        
        if strCardNumber.contains("MASTERCARD") {
            imgV.image      = UIImage(named: "master")
            strCCName       = "MASTERCARD \n"
            strCardNumber   = strCardNumber.replacingOccurrences(of: "MASTERCARD ", with: "")
        }else if strCardNumber.contains("VISA"){
            imgV.image      = UIImage(named: "visa")
            strCCName       = "VISA \n"
            strCardNumber   = strCardNumber.replacingOccurrences(of: "VISA ", with: "")
        }else if strCardNumber.contains("AMEX"){
            imgV.image      = UIImage(named: "amex")
            strCCName       = "AMEX \n"
            strCardNumber   = strCardNumber.replacingOccurrences(of: "AMEX ", with: "")
        }else if strCardNumber.contains("DINER"){
            imgV.image      = UIImage(named: "diner")
            strCCName       = "DINER \n"
            strCardNumber   = strCardNumber.replacingOccurrences(of: "DINER ", with: "")
        }else{
            imgV.image      = UIImage(named: "card_icon")
        }

        
        //UIView
        viewPop.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7.0 * GConstant.Screen.HeightAspectRatio : 5.0)
        
        //Textfields
        txtAmount.applyStyle(textColor: GConstant.AppColor.textDark
            , borderColor: GConstant.AppColor.textDark, borderWidth: 1.0)
        popUpPropertiesUpdate(strCCName: strCCName)
        if txtAmount.isUserInteractionEnabled == true {
            txtAmount.becomeFirstResponder()
        }
    }
    func popUpPropertiesUpdate(strCCName: String) {
        
        if typePopUp == .creditCard {
            lblTitleMethod.isHidden = true
            viewCC.isHidden         = false
        }else{
            lblTitleMethod.isHidden = false
            viewCC.isHidden         = true
        }

        //<--------Set PopUp properties for orientation----->
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            let atrStr                      = NSMutableAttributedString()
            let atrStr1                     = NSAttributedString(string: strCCName, attributes: [NSAttributedStringKey.font: UIFont.applyOpenSansBold(fontSize: 15.0)])
            let atrStr2                     = NSAttributedString(string: strCardNumber, attributes: [NSAttributedStringKey.font: UIFont.applyOpenSansBold(fontSize: 12.0)])
            atrStr.append(atrStr1)
            atrStr.append(atrStr2)
            lblCardNumber.attributedText    = atrStr
            lblTitleMethod.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 16.0))
            btnCancel.titleLabel?.font      = UIFont.applyRegular(fontSize: 12.0)
            btnConfirm.titleLabel?.font     = UIFont.applyRegular(fontSize: 12.0)
            txtAmount.font                  = UIFont.applyOpenSansRegular(fontSize: 11.0)
        }else{
            let atrStr                      = NSMutableAttributedString()
            let atrStr1                     = NSAttributedString(string: strCCName, attributes: [NSAttributedStringKey.font: UIFont.applyOpenSansBold(fontSize: 18.0)])
            let atrStr2                     = NSAttributedString(string: strCardNumber, attributes: [NSAttributedStringKey.font: UIFont.applyOpenSansBold(fontSize: 14.0)])
            atrStr.append(atrStr1)
            atrStr.append(atrStr2)
            lblCardNumber.attributedText    = atrStr
            lblTitleMethod.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 22.0))
            btnCancel.titleLabel?.font      = UIFont.applyRegular(fontSize: 15.0)
            btnConfirm.titleLabel?.font     = UIFont.applyRegular(fontSize: 15.0)
            txtAmount.font                  = UIFont.applyOpenSansRegular(fontSize: 14.0)
        }
        consHeightPopUp.constant        = 0.5 * UIScreen.main.bounds.height
        self.view.layoutIfNeeded()
    }
    
    //MARK: - UIButton & UIViewAction methods
    @IBAction func btnCancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnConfirmAction(_ sender: UIButton) {
        if let amount = txtAmount.text {
            completionHandler(amount)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func viewBackAction(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
}

extension TMPopUPVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = GConstant.AppColor.blue.cgColor
        textField.layer.borderWidth = 1.0
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = GConstant.AppColor.textDark.cgColor
        textField.layer.borderWidth = 1.0
    }
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

