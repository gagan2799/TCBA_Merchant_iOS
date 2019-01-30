//
//  TMHistoryTransDetailCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 03/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryTransDetailCell: UITableViewCell {
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblDate: CustomLabel!
    @IBOutlet weak var lblDetail: CustomLabel!
    @IBOutlet weak var lblAmount: CustomLabel!
    @IBOutlet weak var lblCredits: CustomLabel!
    @IBOutlet weak var lblDebits: CustomLabel!
    @IBOutlet weak var lblNet: CustomLabel!
    @IBOutlet weak var lblBalance: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
