//
//  CircleView.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 20/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius     = self.bounds.midY
        self.layer.borderWidth      = 2.0
        self.layer.borderColor      = GConstant.AppColor.grayBorder.cgColor
        self.layer.masksToBounds    = true
    }
}
