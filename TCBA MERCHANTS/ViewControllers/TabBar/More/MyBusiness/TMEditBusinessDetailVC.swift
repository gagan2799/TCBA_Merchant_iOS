//
//  TMEditBusinessDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 04/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import WebKit

class TMEditBusinessDetailVC: UIViewController {
    
    //MARK: Enum
    enum TypeTitle : String {
        case FeaturedContent    = "Featured Content"
        case TermsAndConditions = "Terms and Conditions"
        case Description        = "Store Description"
        case AboutUs            = "About Us"
    }
    
    enum TypeStore : String  {
        case StoreFeatures      = "storeFeatures"
        case StoreTerm          = "storeTerm"
        case StoreDescription   = "storeDescription"
        case StoreAbout         = "storeAbout"
    }
    //MARK: Enum Object
    
    var titleType : TypeTitle!
    var storeType : TypeStore!
    //MARK: - Outlets
    //WebKit WebView
    @IBOutlet weak var webV: WKWebView!
    //UILable
    @IBOutlet weak var lblInfo: UILabel!
    //UIButton
    @IBOutlet weak var btnSave: UIButton!
    //String
    var strContent = ""
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get Store Details
        self.callGetStoreContentApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
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
    
    //MARK: - View Properties
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title       = titleType.rawValue
        lblInfo.font                    = UIFont.applyOpenSansRegular(fontSize: 15.0)
        lblInfo.text                    = "Delete contents to remove from display on your\n store detail view in the app"
        
        webV.scrollView.isScrollEnabled = true
        webV.scrollView.bounces         = false
        webV.navigationDelegate         = self
        
        DispatchQueue.main.async {
            guard let path                  = Bundle.main.path(forResource:"CKEditor/demo", ofType: "html") else { return }
            let myURL                       = URL(fileURLWithPath: path)
            self.webV.load(URLRequest(url: myURL))
        }
        // NSNotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(resizeEditorHeight), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(resizeEditorHeight), name:UIResponder.keyboardWillHideNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(resizeEditorHeight), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: - UIButton ActionMethods
    @IBAction func btnSaveAction(_ sender: UIButton) {
        webV.evaluateJavaScript("CKEDITOR.instances.editor1.getData()") { (result, error) in
            if error == nil {
                if let str = result as? String{
                    let str1        = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    self.strContent = str1.replacingOccurrences(of: "<p>&nbsp;</p>", with: "")
                    self.callPUTUpdateContentApi(withContent: self.strContent)
                }
            }
        }
    }
    
    //MARK: - Coustom Methods
    @objc func resizeEditorHeight() {
        DispatchQueue.main.async {
            self.webV.evaluateJavaScript("CKEDITOR.instances.editor1.resize( '100%', window.innerHeight)") { (result, error) in
                if error == nil {
                    
                }
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    
    //MARK: - Web Api's
    func callGetStoreContentApi() {
        /*
         =====================API CALL=====================
         APIName    : GetStoreContent
         Url        : "/Stores/GetStoreContent"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeID     = storeId
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStoreContent, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] else { return }
                
                if let strOriginal = json?[self.storeType.rawValue] {
                    
                    let squashed        = (strOriginal as NSString?)?.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: NSRange(location: 0, length: strOriginal.count ))
                    let strDescription  = "document.getElementById('editor1').innerHTML='\(squashed?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "")'"
                    self.strContent     = strDescription
                    self.webV.evaluateJavaScript(strDescription, completionHandler: { (result, error) in
                        
                    })
                }
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
    
    func callPUTUpdateContentApi(withContent content: String) {
        /*
         =====================API CALL=====================
         APIName    : PutUpdateStoreContent
         Url        : "/Stores/PutUpdateStoreContent"
         Method     : PUT
         Parameters : { TypeStore.RawValue  : "<p>Cash Back on great on offers and services direct from The Cash Back App</p>",
         storeId             : 283
         }
         ===================================================
         */
        
        let request = RequestModal.mUpdateStoreContent()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeId     = storeId
        if storeType == .StoreFeatures {
            request.storeFeatures       = content
        } else if storeType == .StoreAbout {
            request.storeAbout          = content
        } else if storeType == .StoreDescription {
            request.storeDescription    = content
        } else {
            request.storeTerm           = content
        }
        
        ApiManager.shared.PUTWithBearerAuth(strURL: GAPIConstant.Url.PutUpdateStoreContent, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success", message: GConstant.Message.kUpdatesSaveMessage)
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
}

extension TMEditBusinessDetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webV.evaluateJavaScript(strContent, completionHandler: { (result, error) in
            
        })
    }
}
