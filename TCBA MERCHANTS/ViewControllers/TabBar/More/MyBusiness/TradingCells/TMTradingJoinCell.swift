//
//  TMTradingJoinCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 07/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMTradingJoinCell: UITableViewCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblStart1: UILabel!
    @IBOutlet weak var lblEnd: UILabel!
    @IBOutlet weak var lblEnd1: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
