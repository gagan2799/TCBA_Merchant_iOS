//
//  TMCalculatorCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 08/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMCalculatorCell: UITableViewCell {
    //UIlabel
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    //UITextField
    @IBOutlet weak var txtSpendWeek: UITextField!
    @IBOutlet weak var txtSaveWeek: UITextField!
    @IBOutlet weak var txtSaveYear: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
