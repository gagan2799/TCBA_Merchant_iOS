//
//  TMStaffMasterCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 24/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMStaffMasterCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPin: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
