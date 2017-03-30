//
//  CustomCell.swift
//  EDraft
//
//  Created by Devin Tripp on 3/17/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var TeamTwoLabel: UILabel!
    @IBOutlet weak var TeamTwoPhoto: UIImageView!
    @IBOutlet weak var TeamOnePhoto: UIImageView!
    @IBOutlet weak var TeamOneLabel: UILabel!
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
