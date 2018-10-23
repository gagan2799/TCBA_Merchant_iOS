//
//  TMCalculatorHeaderCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 08/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMCalculatorHeaderCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpendWeek: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblSaveWeek: UILabel!
    @IBOutlet weak var lblSaveYear: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
