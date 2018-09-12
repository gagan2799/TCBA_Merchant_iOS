//
//  TMBankDetailsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import MessageUI

class TMBankDetailsVC: UIViewController {
    
    //MARK: - Outlets
    //UILabel
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBSB: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    //UITextfield
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBSB: UITextField!
    @IBOutlet weak var txtAccount: UITextField!
    
    //UIButton
    @IBOutlet weak var btnTermOfUse: UIButton!
    
    //String
    let text = "To change your business details,\nplease Contact us"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title       = "Bank Details"
        let textSize: CGFloat           = 15.0
        lblName.font                    = UIFont.applyOpenSansRegular(fontSize: textSize)
        lblBSB.font                     = UIFont.applyOpenSansRegular(fontSize: textSize)
        lblAccount.font                 = UIFont.applyOpenSansRegular(fontSize: textSize)
        txtName.font                    = UIFont.applyOpenSansRegular(fontSize: textSize)
        txtBSB.font                     = UIFont.applyOpenSansRegular(fontSize: textSize)
        lblBSB.font                     = UIFont.applyOpenSansRegular(fontSize: textSize)
        lblInfo.font                    = UIFont.applyOpenSansRegular(fontSize: textSize)
        btnTermOfUse.titleLabel?.font   = UIFont.applyOpenSansRegular(fontSize: textSize)
        
        // create attributed string
        let attributes                  = [NSAttributedStringKey.foregroundColor:GConstant.AppColor.blue , NSAttributedStringKey.font: UIFont.applyOpenSansSemiBold(fontSize: textSize) , NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        
        let underlineAttriString        = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Contact us")
        underlineAttriString.addAttributes(attributes, range: range)
        lblInfo.attributedText = underlineAttriString
        let taplblinfo                  = UITapGestureRecognizer(target: self, action: #selector(TMBankDetailsVC.tapLabel))
        lblInfo.addGestureRecognizer(taplblinfo)
    }
    
    //MARK: - UIButton Action
    @IBAction func btnTermAction(_ sender: UIButton) {
        let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.TermOfUse) as! TMTermOfUseVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK: - TapGesture Method
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let range = (text as NSString).range(of: "Contact us")
        if gesture.didTapAttributedTextInLabel(label: lblInfo, inRange: range) {
            sendEmail()
        }
    }
}

extension TMBankDetailsVC: MFMailComposeViewControllerDelegate  {
    //MARK: - Mail Composer
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate    = self
            mail.setToRecipients([GConstant.kMerchantEmail])
            guard let userId            = GConstant.UserData.userID else { return }
            mail.setMessageBody(String.init(format: "Please update my bank details Mechant ID: %@",userId), isHTML: false)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    //MARK: - Mail Composer Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
