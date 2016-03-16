//
//  DBTableViewCell.swift
//  HumanPatternCycle
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class DBTableViewCell: UITableViewCell {

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var cloud: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
