//
//  TMCardTVCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 22/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMCardTVCell: UITableViewCell {
    @IBOutlet weak var imgVIcon: UIImageView!
    @IBOutlet weak var lblCardNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
