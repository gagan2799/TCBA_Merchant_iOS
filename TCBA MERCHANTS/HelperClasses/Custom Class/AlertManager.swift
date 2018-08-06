//
//  AlertManager.swift
//  Trailer2You
//
//  Created by SIERRA on 4/6/18.
//  Copyright © 2018 GsBitLabs. All rights reserved.
//

import UIKit
import SIAlertView

let kColorGray74:Int    = 0xBDBDBD

class AlertManager: NSObject , UIAlertViewDelegate {

    static let shared : AlertManager = AlertManager()
    
    var completionBlock: ((_ selectedIndex: Int) -> Void)? = nil
    
    func showAlertTitle(title : String?
        , message : String?
        , buttonsArray : [Any] = ["OK"]
        , completionBlock : ((_ : Int) -> ())? = nil) {

        self.completionBlock = completionBlock
        
        let alertView : SIAlertView = SIAlertView(title: title, andMessage: message)
        for i in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[i] as! String
            alertView.addButton(withTitle: buttonTitle, type: .default, handler: { (_ alertView : SIAlertView?) in

                if self.completionBlock != nil {
                    
                    self.completionBlock!(i)
                }
            })
        }
        
        alertView.cornerRadius = 2
        alertView.viewBackgroundColor = GConstant.AppColor.white
        alertView.transitionStyle = .bounce
        alertView.titleColor = GConstant.AppColor.black
        alertView.titleFont = UIFont.applyBold(fontSize: 16.0, isAspectRasio: false)
        alertView.messageColor = GConstant.AppColor.black
        alertView.messageFont = UIFont.applyRegular(fontSize: 13.0, isAspectRasio: false)
        alertView.buttonColor = GConstant.AppColor.black
        alertView.show()
     
        for containerView: UIView in alertView.subviews {
            if (containerView is UIView) {
                containerView.layer.borderColor = UIColor.colorFromHex(hex: kColorGray74).cgColor
                containerView.layer.borderWidth = 0.50
                for button in containerView.subviews {
                    if (button is UIButton) {
                        let button = button as! UIButton
                        button.backgroundColor = GConstant.AppColor.white
                        button.setBackgroundImage(nil, for: .normal)
                        button.setBackgroundImage(nil, for: .highlighted)
                        button.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 12.0, isAspectRasio: false), titleLabelColor: GConstant.AppColor.black, borderColor : GConstant.AppColor.white, borderWidth : 0.50)
                        button.setTitle(button.titleLabel?.text, for: .normal)
                    }
                }
            }
        }
        
    }
    
    func showPopUpAlert(_ title : String?
        , message : String?
        , forTime time : Double
        , completionBlock : ((_ : Int) -> ())? = nil) {
    
        self.completionBlock = completionBlock
        
        let alertView : SIAlertView = SIAlertView(title: title, andMessage: message)
        alertView.transitionStyle = .fade
        alertView.cornerRadius = 2
        alertView.viewBackgroundColor = GConstant.AppColor.white
        alertView.titleColor = GConstant.AppColor.black
        alertView.titleFont = UIFont.applyBold(fontSize: 16.0,isAspectRasio: false)
        alertView.messageColor = GConstant.AppColor.black
        alertView.messageFont = UIFont.applyRegular(fontSize: 13.0,isAspectRasio: false)
        alertView.buttonColor = GConstant.AppColor.black
        alertView.show()
        
        for containerView: UIView in alertView.subviews {
            if (containerView is UIView) {
                containerView.layer.borderColor = UIColor.colorFromHex(hex: kColorGray74).cgColor
                containerView.layer.borderWidth = 0.50
                for button in containerView.subviews {
                    if (button is UIButton) {
                        let button = button as! UIButton
                        button.backgroundColor = GConstant.AppColor.white
                        button.setBackgroundImage(nil, for: .normal)
                        button.setBackgroundImage(nil, for: .highlighted)
                        button.applyStyle(titleLabelFont: UIFont.applyBold(fontSize: 12.0,isAspectRasio: false), titleLabelColor: GConstant.AppColor.black, borderColor : GConstant.AppColor.white, borderWidth : 0.50)
                        button.setTitle(button.titleLabel?.text, for: .normal)
                    }
                }
            }
        }
            
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alertView.dismiss(animated: true)
            if completionBlock != nil {
                completionBlock!(0)
            }
        })
        
    }
    
}
