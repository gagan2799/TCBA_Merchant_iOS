//
//  TMStoreImagesCell.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 12/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMStoreImagesCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
