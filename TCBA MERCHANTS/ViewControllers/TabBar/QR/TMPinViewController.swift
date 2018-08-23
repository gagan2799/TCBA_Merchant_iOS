//
//  TMPinViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMPinViewController: UIViewController {

    //MARK: Outlets & Variables
    var completionHandler: ((_ qrcode : String) -> Void)!
    var method              = String()
    var balance             = String()
    var amount   = String()
    
    //UIButton
    @IBOutlet weak var btnCancel: UIButton!
    //UIView
    @IBOutlet weak var viewBack: UIControl!
    @IBOutlet weak var viewPop: UIView!
    //UILabel
    @IBOutlet weak var lblTitleMethod: UILabel!
    @IBOutlet weak var lblCurr: UILabel!
    @IBOutlet weak var lblCurBal: UILabel!
    @IBOutlet weak var lblTransAmount: UILabel!
    @IBOutlet weak var lblTrans: UILabel!
    @IBOutlet weak var lblEnter: UILabel!
    @IBOutlet weak var lblEnter2: UILabel!
    
    //UITextfield
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    //Constraints
    @IBOutlet weak var consHeightLblCurr: NSLayoutConstraint!
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
    
        lblTitleMethod.text     = method
        lblCurBal.text          = "$"+balance
        lblTransAmount.text     = "$"+amount
        //UIView
        viewPop.applyCornerRadius(cornerRadius: UIDevice.current.userInterfaceIdiom == .pad ? 7.0 * GConstant.Screen.HeightAspectRatio : 5.0)
        //Textfields
        txt1.applyStyle(textColor: GConstant.AppColor.textDark
            , borderColor: GConstant.AppColor.textDark, borderWidth: 1.0)
        txt2.applyStyle(textColor: GConstant.AppColor.textDark
            , borderColor: GConstant.AppColor.textDark, borderWidth: 1.0)
        txt3.applyStyle(textColor: GConstant.AppColor.textDark
            , borderColor: GConstant.AppColor.textDark, borderWidth: 1.0)
        txt4.applyStyle(textColor: GConstant.AppColor.textDark
            , borderColor: GConstant.AppColor.textDark, borderWidth: 1.0)
        txt1.becomeFirstResponder()
        

        popUpPropertiesUpdate()
    }
    
    func popUpPropertiesUpdate() {
        if balance == "" {
            lblCurr.isHidden    = true
            lblCurBal.isHidden  = true
            consHeightLblCurr.constant  = 0.0
            consHeightPopUp.constant    = 0.55 * UIScreen.main.bounds.height
        }else{
            lblCurr.isHidden    = false
            lblCurBal.isHidden  = false
            consHeightLblCurr.constant  = 0.05 * UIScreen.main.bounds.height
            consHeightPopUp.constant    = 0.6 * UIScreen.main.bounds.height
        }
        self.view.layoutIfNeeded()
        //<--------Set PopUp properties for orientation----->
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            lblTitleMethod.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 16.0))
            lblCurr.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 11.0))
            lblTrans.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 11.0))
            lblCurBal.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 11.0))
            lblTransAmount.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 11.0))
            lblEnter.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 12.0))
            lblEnter2.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 9.0))
            
            btnCancel.titleLabel?.font  = UIFont.applyRegular(fontSize: 12.0)
            
            txt1.font                   = UIFont.applyOpenSansRegular(fontSize: 11.0)
            txt2.font                   = UIFont.applyOpenSansRegular(fontSize: 11.0)
            txt3.font                   = UIFont.applyOpenSansRegular(fontSize: 11.0)
            txt4.font                   = UIFont.applyOpenSansRegular(fontSize: 11.0)
        }else{
            lblTitleMethod.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 22.0))
            lblCurr.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 14.0))
            lblTrans.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 14.0))
            lblCurBal.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 14.0))
            lblTransAmount.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 14.0))
            lblEnter.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 15.0))
            lblEnter2.applyStyle(labelFont: UIFont.applyOpenSansSemiBold(fontSize: 12.0))
            
            btnCancel.titleLabel?.font  = UIFont.applyRegular(fontSize: 15.0)
            
            txt1.font                   = UIFont.applyOpenSansRegular(fontSize: 14.0)
            txt2.font                   = UIFont.applyOpenSansRegular(fontSize: 14.0)
            txt3.font                   = UIFont.applyOpenSansRegular(fontSize: 14.0)
            txt4.font                   = UIFont.applyOpenSansRegular(fontSize: 14.0)
        }
    }
    //MARK: - UIButton & UIViewAction methods
    @IBAction func btnCancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewBackAction(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
}
extension TMPinViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = GConstant.AppColor.blue.cgColor
        textField.layer.borderWidth = 1.0
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = GConstant.AppColor.textDark.cgColor
        textField.layer.borderWidth = 1.0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt1 {
            txt2.becomeFirstResponder()
        } else if textField == txt2 {
            txt3.becomeFirstResponder()
        } else if textField == txt3 {
            txt4.becomeFirstResponder()
        } else {
            txt4.resignFirstResponder()
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 1 && textField == txt1{
            txt2.becomeFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if newLength >= 1 {

            let str     = NSString.localizedStringWithFormat("%@", textField.text!)
            textField.text = str.replacingCharacters(in: range, with: string)
            
            if textField == txt1 {
                txt2.becomeFirstResponder()
            } else if textField == txt2 {
                txt3.becomeFirstResponder()
            } else if textField == txt3 {
                txt4.becomeFirstResponder()
            }else{
                txt4.resignFirstResponder()
            }
            if range.length + range.location > (txt4.text?.count)! {
                return false
            }
            let pinStr = "\(txt1.text ?? "")\(txt2.text ?? "")\(txt3.text ?? "")\(txt4.text ?? "")"
            if pinStr.count == 4 {
                completionHandler(pinStr)
                dismiss(animated: true, completion: nil)
                return newLength <= 1
            }
            return false
        } else {
            textField.text = ""
            if textField == txt4 {
                txt3.becomeFirstResponder()
            } else if textField == txt3 {
                txt2.becomeFirstResponder()
            } else if textField == txt2 {
                txt1.becomeFirstResponder()
            }
            return false
        }
        return true
    }
}