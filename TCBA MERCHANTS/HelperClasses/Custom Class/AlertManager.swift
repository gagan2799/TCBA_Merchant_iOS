//
//  AlertManager.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 10/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import UIKit

class AlertManager: NSObject {
    
    static let shared : AlertManager = AlertManager()
    
    var completionBlock: ((_ selectedIndex: Int) -> Void)? = nil
    
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
        rootWindow().rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showPopUpAlert(_ title : String?
        , message : String?
        , forTime time : Double = 2.0
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        rootWindow().rootViewController?.present(alert, animated: true, completion: nil)
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
        
        rootWindow().rootViewController?.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alert.dismiss(animated: true)
            if completionBlock != nil {
                completionBlock!(0)
            }
        })
    }
}

