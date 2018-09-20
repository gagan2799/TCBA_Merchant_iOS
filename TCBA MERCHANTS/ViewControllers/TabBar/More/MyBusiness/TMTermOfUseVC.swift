//
//  TMTermOfUseVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 12/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import WebKit

class TMTermOfUseVC: UIViewController {
    //MARK: - Outlets
    //WebKit WebView
    @IBOutlet weak var webV: WKWebView!

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
        webV.navigationDelegate     = self
        GFunction.shared.addLoader()
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Terms of use"
        
        let urlAddress              = "<p>As a TCBA Merchant you have agreed to merchant terms of service. Among these terms is that you will maintain the bank account listed here (that you provided to us) as the account that we will debit funds owed from member purchases.</p><p>You, too, have also agreed to and accepted our Direct Debit Request and Authority that authorises us to debit funds from this bank account on a nightly basis.</p><p>Funds will be debited nightly or when there is a minimum of $10 dollars that is owed to us.</p><p>You also agree that if you change your bank account, or need it to be changed, you will notify us immediately with your new details.</p><p>Debits that fail as a result of incorrect or changed bank accounts will result in immediate suspension of your TCBA Merchant account until your bank details are corrected.</p><p>Please see your merchant agreement online for more details. Contact merchants@thecashbackapp.com for any issues.</p>"
        let fontSize                = "\(floor(16*GConstant.Screen.HeightAspectRatio))"
        let embedHTML               = String.init(format: "<html><body><div style='font-family:OpenSans; font-size:%@; color=#4c4c4c'>%@</div></body></html>",fontSize, urlAddress)
        webV.loadHTMLString(embedHTML, baseURL: nil)
    }
}

extension TMTermOfUseVC: WKNavigationDelegate {
    //MARK: WebKit navigation delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GFunction.shared.removeLoader()
    }
}
