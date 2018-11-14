//
//  CustomLabel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 14/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import UIKit
class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}
