//
//  TMPaymentSuccessCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 30/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMPaymentSuccessCell: UITableViewCell {
    @IBOutlet weak var lblMethod: UILabel!
    @IBOutlet weak var lblMethodVal: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountVal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
