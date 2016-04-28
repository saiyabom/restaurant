//
//  RestaurantTableViewCell.swift
//  Restaurant
//
//  Created by user on 2/19/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

  
    @IBOutlet var imageRestaurant: UIImageView!
    
    @IBOutlet var nameRestaurant: UILabel!
   
    @IBOutlet var typeRestanrant: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
