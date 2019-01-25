//
//  AlertManager.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 10/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import UIKit

struct VAlert {
    let title:String?
    let message:String?
}

class AlertManager: NSObject {
    
    static let shared : AlertManager = AlertManager()
    
    var completionBlock: ((_ selectedIndex: Int) -> Void)? = nil
    
    // This alert fuction getting prob to show multiline alert , i dont know it's Apple's bug or something wrong with my project if you got this prob Coment this and un coment below method
    
    func showAlertTitle(title: String, message: String, buttonsArray : [Any] = ["OK"]
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[i] as! String
            alertController.addAction(UIAlertAction.init(title: buttonTitle, style: .default, handler: { (action) in
                if self.completionBlock != nil {
                    self.completionBlock!(i)
                }
            }))
        }
        //     rootWindow().rootViewController?.present(alertController, animated: true, completion: nil)
        alertController.presentAlert()
    }
    
    func showPopUpAlert(_ title : String?
        , message : String?
        , forTime time : Double = 2.0
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        rootWindow().rootViewController?.present(alert, animated: true, completion: nil)
        alert.presentAlert()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alert.dismiss(animated: true)
            if completionBlock != nil {
                completionBlock!(0)
            }
        })
    }
    
    func showToast(_ title : String?
        , message : String?
        , forTime time : Double = 2.0
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        
//        rootWindow().rootViewController?.present(alert, animated: true, completion: nil)
        alert.presentAlert()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alert.dismiss(animated: true)
            if completionBlock != nil {
                completionBlock!(0)
            }
        })
    }
}

