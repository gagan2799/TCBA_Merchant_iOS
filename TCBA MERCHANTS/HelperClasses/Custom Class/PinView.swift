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
    
    func showPinView(withTitle: String, currentBalance: String,transactionAmount: String, buttonsArray : [Any] = ["CANCEL"]
        , completionBlock : ((_ : Int) -> ())? = nil) {
        
        self.completionBlock = completionBlock
        
        let pinView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        pinView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFromTop
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        rootWindow().layer.add(transition, forKey: kCATransition)
        rootWindow().addSubview(pinView)
    }
}
