//
//  MenuTableCell.swift
//  Restaurant
//
//  Created by user on 2/22/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {
    
    
    @IBOutlet var imageMenuCell: UIImageView!

    @IBOutlet var costMenu: UILabel!
    @IBOutlet var nameMenu: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
