//
//  TMVideoDetailsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 05/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import WebKit

class TMVideoDetailsVC: UIViewController , WKNavigationDelegate{
    //MARK: Variables & Constants
    var objVideoSub: VideoSubCategoryVideo!
    var indicator: UIActivityIndicatorView!
    //MARK: Outlets
    //WebKit
    @IBOutlet weak var webV: WKWebView!
    //UILabel
    @IBOutlet weak var lblTitle: UILabel!
    //UITextView
    @IBOutlet weak var txtView: UITextView!
    //UIView
    @IBOutlet weak var viewContainer: UIView!
    
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
    
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Videos"
        webV.navigationDelegate     = self
        
        guard let htmlText = objVideoSub?.videoDescription  else { return }
        DispatchQueue.main.async {
            self.txtView.attributedText  = htmlText.html2AttributedStringWithCustomFont
            self.indicator                   = UIActivityIndicatorView.init(style: .gray)
            self.indicator.frame             = CGRect(x: self.view.center.x - 10, y: self.webV.bounds.midY, width: 20, height: 20)
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
        
        loadYoutube(videoURL: objVideoSub?.videoLink ?? "")
        lblTitle.font               = UIFont.applyOpenSansRegular(fontSize: 16.0)
        lblTitle.text               = objVideoSub?.videoTitle
        viewContainer.applyViewShadow(shadowOffset: CGSize(width: 0.5, height: 0.5), shadowColor: UIColor.lightGray, shadowOpacity: 50.0, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, backgroundColor: UIColor.white, backgroundOpacity: nil)
        
    }
    
    func loadYoutube(videoURL:String) {
        let videoID = videoURL.components(separatedBy: "=")
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID[1])")
            else { return }
        webV.load(URLRequest(url: youtubeURL))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.isHidden  = true
        indicator.removeFromSuperview()
    }
}
