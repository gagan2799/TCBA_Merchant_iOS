//
//  TMStorePaymentTVCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 21/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMStorePaymentTVCell: UITableViewCell {
    @IBOutlet weak var imgVTV: UIImageView!
    
    @IBOutlet weak var vBlueLine: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBal: UILabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblAmtPaid: UILabel!
    
    @IBOutlet weak var consLblWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
