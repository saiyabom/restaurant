//
//  Restaurant.swift
//  test
//
//  Created by user on 2/17/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Restaurant{
    
    dynamic var id : String!
    dynamic var restaurantName : String!
    dynamic var typeName : String!
    dynamic var description : String!
    dynamic var imageUrl : String!
    dynamic var deliverCost :String!
    init(){
    }
        init(json: JSON){
        self.id = json["_id"].string
        self.restaurantName = json["res_name"].string
        self.typeName = json["res_detail"].string
        self.description = json["res_detail"].string
        self.imageUrl = json["res_img"].string
        self.deliverCost = json["res_location"]["data"].array![0]["cost"].string
    }
    
}
