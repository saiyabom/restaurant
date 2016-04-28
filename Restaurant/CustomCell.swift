//
//  CustomCell.swift
//  Restaurant
//
//  Created by user on 3/9/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet weak var orderCreatedDate: UILabel!
    @IBOutlet weak var orderCreatedTime: UILabel!
    @IBOutlet weak var costOrder: UILabel!
    
    
    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var foodDesc: UILabel!
    @IBOutlet weak var foodCost: UILabel!
    @IBOutlet weak var foodNumber: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
