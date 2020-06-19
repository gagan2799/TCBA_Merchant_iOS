//
//  TMMainImageVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import MessageUI

class TMMainImageVC: UIViewController {


    //MARK: - Variables
    var titleNav: String!
    var imgUrl  : String!
    var storeTitle: String!
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnMerchantSupport: UIButton!
    
    //String
    let text = "Please Contact Merchant Support\nto change images."
    
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
        self.navigationItem.title   = title
        lblInfo.font                = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        if let url = URL(string: imgUrl) {
            imgV.setImageWithDownload(url)
        }
        
        // create attributed string
        let attributes                  = [NSAttributedString.Key.foregroundColor:GConstant.AppColor.blue , NSAttributedString.Key.font: UIFont.applyOpenSansSemiBold(fontSize: 15.0)] as [NSAttributedString.Key : Any]
        
        let underlineAttriString        = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Merchant Support")
        underlineAttriString.addAttributes(attributes, range: range)
        lblInfo.attributedText = underlineAttriString
        let taplblinfo                  = UITapGestureRecognizer(target: self, action: #selector(TMMainImageVC.tapLabel))
        lblInfo.addGestureRecognizer(taplblinfo)
    }
    
    //MARK: UIButton
    @IBAction func btnMerchantAction(_ sender: UIButton) {
        sendEmail()
    }
    
    //MARK: - TapGesture Method
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let range = (text as NSString).range(of: "Merchant Support")
        if gesture.didTapAttributedTextInLabel(label: lblInfo, inRange: range) {
            sendEmail()
        }
    }
}

extension TMMainImageVC: MFMailComposeViewControllerDelegate  {
    //MARK: - Mail Composer
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate    = self
            mail.setToRecipients([GConstant.kMerchantEmail])
            guard let userId            = GConstant.UserData?.userID else { return }
            mail.setMessageBody("Store image change request: \(storeTitle ?? "") - \(userId)", isHTML: false)
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

