//
//  CartCell.swift
//  Restaurant
//
//  Created by user on 2/23/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var imageFood: UIImageView!
    
    
    @IBOutlet weak var numberOfFood: UILabel!
    
    @IBOutlet weak var nameFood: UILabel!
    
    
    @IBOutlet weak var costPerFood: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
