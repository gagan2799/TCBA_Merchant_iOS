//
//  TMHistoryDetailTableCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 07/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryDetailTableCell: UITableViewCell {

    @IBOutlet weak var lblDateOrID: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVArrowNext: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
