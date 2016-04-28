//
//  RestaurantInfo.swift
//  Restaurant
//
//  Created by user on 2/22/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON

class RestaurantInfo{
    var restaurant_id : String // ID of Restaurant
    var restaurant_image_url : String! // URL image of Restaurant
    var delivery_cost : String
    var listMenu : [Menu]
    /*init(data : NSDictionary){
        self.restaurant_id = data["restaurant_id"] as! String
        self.restaurant_image_url = data["restaurant_image_url"] as! String
        self.number_menu = data["number_menu"] as! Int
        self.listMenu = [Menu]()
    
        
    }*/
    init(json : JSON, restaurant: Restaurant){
        self.restaurant_id = restaurant.id
        self.restaurant_image_url = restaurant.imageUrl
        self.delivery_cost = restaurant.deliverCost
        let list_menu =  json["data"].array
        //print(list_menu.debugDescription)
        
        self.listMenu = [Menu]()
        
        for var i=0; i<list_menu?.count; i++ {
            let menuItem = Menu(json: list_menu![i],cost: self.delivery_cost)
            self.listMenu.append(menuItem)
            
        }
        print(self.listMenu.count)
        print(self.listMenu[0].menu_name!)
    }

}
