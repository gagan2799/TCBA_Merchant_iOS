//
//  TMHistoryTableViewCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 01/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotalDebs: UILabel!
    @IBOutlet weak var lblTotalDebValue: UILabel!
    @IBOutlet var lblSubTitles: [UILabel]!
    @IBOutlet weak var lblTransaction: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var viewOrange: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
