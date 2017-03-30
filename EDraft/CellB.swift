//
//  CellB.swift
//  EDraft
//
//  Created by Devin Tripp on 3/24/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit

class CellB: UITableViewCell {

    @IBOutlet weak var amountOfBet: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
