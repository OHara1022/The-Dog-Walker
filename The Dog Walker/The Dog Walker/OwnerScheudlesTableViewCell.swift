//
//  OwnerScheudlesTableViewCell.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/17/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit

class OwnerScheudlesTableViewCell: UITableViewCell {
    
    //set label outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
