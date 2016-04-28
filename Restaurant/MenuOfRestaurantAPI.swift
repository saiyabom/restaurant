//
//  MenuOfRestaurantAPI.swift
//  Restaurant
//
//  Created by user on 2/22/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class MenuOfRestaurantAPI:API{
    var restaurant :Restaurant?
    init(author:String,content:String){
        super.init(Authorization: author, ContentType: content)
        
    }
    init(restaurant: Restaurant){
        super.init(Authorization: "",ContentType: "")
        self.restaurant = restaurant
    }
    func loadMenuOfRestaurant(completion: ((RestaurantInfo) -> Void)!){
        // .Get Menu of Restaurant
        //let urlString = "http://beta.json-generator.com/api/json/get/VkS-S7Ese"
         let urlString = "http://innovationknock.com:1200/menu/\(self.restaurant!.id!)"
         
        Alamofire.request(.GET, urlString).responseJSON(completionHandler: { response in
        
            let jsonAbc = JSON(response.result.value!)
            let restaurantInfo = RestaurantInfo(json: jsonAbc,restaurant: self.restaurant!)
            
            completion(restaurantInfo)
        })

        
    }
    
    
}