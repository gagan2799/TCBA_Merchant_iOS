//
//  TMStaffLoginVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMStaffLoginVC: UIViewController {
    
    enum userType {
        case merchant
        case staff
    }
    //MARK: Variables & Constants
    var completionHandler   : ((_ password : String) -> Void)!
    var userT: userType!
    
    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtPin: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: View Life Cycle
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
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //Mark: setViewProperties
    func setViewProperties() {
        
        lblTitle.font = UIFont.applyOpenSansRegular(fontSize: 15.0)
        txtPin.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 15.0), textColor: GConstant.AppColor.textDark, cornerRadius: nil, borderColor: GConstant.AppColor.blue, borderWidth: 1.0)
        
        
        if userT == .merchant {
            //Merchant
            lblTitle.text       = "Enter Your Merchant Password"
            txtPin.placeholder  = "Enter Password"
            txtPin.keyboardType = .default
        } else {
            //Staff
            btnSave.isHidden    = true
            lblTitle.text       = "Enter your Staff PIN Code to Login to Staff Mode"
            txtPin.placeholder  = "Enter PIN"
            txtPin.keyboardType = UIDevice.current.userInterfaceIdiom == .pad ? .numbersAndPunctuation: .numberPad
        }
        
        txtPin.becomeFirstResponder()
    }
    
    //MARK: - UIButton Action Method
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if txtPin.text == "" {
            AlertManager.shared.showAlertTitle(title: "Error", message: "Please enter your password")
        }else{
            completionHandler(txtPin.text ?? "")
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func viewBackAction(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension TMStaffLoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if userT == .staff {
            if range.length + range.location > textField.text?.count ?? 0 {
                return false
            }
            let newLength = (textField.text?.count)! + string.count - range.length
            let compSepByCharInSet  = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
            let strFiltered         = compSepByCharInSet.joined(separator: "")
            if string == strFiltered {
                let nsStr           = textField.text as NSString? ?? ""
                let str             = nsStr.replacingCharacters(in: range, with: string).replacingOccurrences(of: ".", with: "")
                let range: NSRange  = (str as NSString).range(of: "^0*", options: .regularExpression)
                let newPin          = (str as NSString).replacingCharacters(in: range, with: "")
                txtPin.text         = newPin
                if newLength == 4 {
                    completionHandler(newPin)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
        return userT == .staff ? false : true
    }
}
