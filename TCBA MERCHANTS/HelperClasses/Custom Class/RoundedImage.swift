//
//  RoundedImage.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 09/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius     = self.bounds.midY
        self.layer.borderWidth      = 2.0
        self.layer.borderColor      = UIColor.white.cgColor
        self.layer.masksToBounds    = true
    }
}
