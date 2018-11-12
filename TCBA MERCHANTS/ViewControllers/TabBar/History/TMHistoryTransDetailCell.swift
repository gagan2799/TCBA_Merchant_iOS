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
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCredits: UILabel!
    @IBOutlet weak var lblDebits: UILabel!
    @IBOutlet weak var lblNet: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
