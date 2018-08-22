//
//  PinView.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 22/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import UIKit

class PinView: NSObject {
    
    static let shared : PinView = PinView()
    
    var completionBlock: ((_ selectedIndex: Int) -> Void)? = nil
    
    func showPinViewWithTitleCurBalTransAmt(title: String, currentBalance: String,transactionAmount: String, buttonsArray : [Any] = ["CANCEL"]
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let pinView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        pinView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
//        for i in 0..<buttonsArray.count {
//            let buttonTitle: String = buttonsArray[i] as! String
//            alertController.addAction(UIAlertAction.init(title: buttonTitle, style: .default, handler: { (action) in
//                if self.completionBlock != nil {
//                    self.completionBlock!(i)
//                }
//            }))
//        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        rootWindow().layer.add(transition, forKey: kCATransition)

    }
}
