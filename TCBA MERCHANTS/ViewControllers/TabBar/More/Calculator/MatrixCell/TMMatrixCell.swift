//
//  TMMatrixCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMatrixCell: UITableViewCell {

    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var txtPeople: UITextField!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var txtIncWeek: UITextField!
    @IBOutlet weak var txtIncYear: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
