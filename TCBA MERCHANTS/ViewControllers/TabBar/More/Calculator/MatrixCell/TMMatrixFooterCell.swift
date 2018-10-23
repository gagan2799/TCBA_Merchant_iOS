//
//  TMMatrixFooterCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMatrixFooterCell: UITableViewCell {

    //UILable
    @IBOutlet weak var lblTotal: UILabel!
    
    //UITextfield
    @IBOutlet weak var txtTotalPeople: UITextField!
    @IBOutlet weak var txtTotalIncWeek: UITextField!
    @IBOutlet weak var txtTotalIncYear: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
