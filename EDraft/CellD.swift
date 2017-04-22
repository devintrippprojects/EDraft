//
//  CellD.swift
//  EDraft
//
//  Created by Devin Tripp on 4/15/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit

class CellD: UITableViewCell {
    @IBOutlet weak var winOrLoseTwo: UILabel!
    @IBOutlet weak var winOrLoseOne: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var scoreOne: UILabel!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var scoreTwo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
