//
//  TMContactDetailsCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 18/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMContactDetailsCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtTitleVal: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
