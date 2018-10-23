//
//  TMMatrixHeaderCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMatrixHeaderCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtAverageSpend: UITextField!
    @IBOutlet weak var lblAverageSpend: UILabel!
    @IBOutlet weak var lblLevelH: UILabel!
    @IBOutlet weak var lblPeopleH: UILabel!
    @IBOutlet weak var lblPercentageH: UILabel!
    @IBOutlet weak var lblIncWeekH: UILabel!
    @IBOutlet weak var lblIncYearH: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
