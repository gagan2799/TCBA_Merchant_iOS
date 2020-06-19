//
//  TMApplyMerchantVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 18/01/19.
//  Copyright © 2019 GS Bit Labs. All rights reserved.
//

import UIKit
import Foundation
import WebKit
class TMApplyMerchantVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var webViewAM: WKWebView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title       = "Apply to be a Merchant"
        webViewAM.navigationDelegate    = self
        DispatchQueue.main.async {
            GFunction.shared.addLoader()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            guard let userID    = GConstant.UserData?.userID else { return }
            guard let url       = URL(string: "https://thecashbackapp.com/appinput/merchant-apply/\(userID)")
                else { return }
            let request         = URLRequest(url: url)
            self.webViewAM.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //            GFunction.shared.removeLoader()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension TMApplyMerchantVC: WKNavigationDelegate {
    //MARK: WebKit navigation delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            GFunction.shared.removeLoader()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
