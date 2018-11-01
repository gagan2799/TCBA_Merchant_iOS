//
//  TMPremiumCardCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 01/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMPremiumCardCell: UITableViewCell {
    @IBOutlet weak var imgVIcon: UIImageView!
    @IBOutlet weak var lblCardNo: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
