//
//  RestaurantAPI.swift
//  test
//
//  Created by user on 2/17/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RestaurantAPI:API{
    init(author:String,content:String){
        super.init(Authorization: author, ContentType: content)
        
    }
    init(){
        super.init(Authorization: "", ContentType: "")
    }
    func loadRestaurants(location: CLLocationCoordinate2D?,completion: (([Restaurant]) -> Void)!){
        //let urlString = "http://beta.json-generator.com/api/json/get/E1KwKoaqx"
        let urlString = "http://innovationknock.com:1200/resturant/rout"
        
        
        
        Alamofire.request(.GET, urlString).responseJSON(completionHandler: { response in
            let json :JSON
            if response.result.isSuccess{
                json = JSON(response.result.value!)
                var restaurants = [Restaurant]()
                let restaurantsJSON = json["data"].array
                for i in 0 ..< restaurantsJSON!.count {
                    let restaurant = Restaurant(json: restaurantsJSON![i])
                    restaurants.append(restaurant)
                }
                completion(restaurants)
            }
            //print("Data:Alamofire \(jsonValue)")
            //let json = JSON(data: data!)
            
            
        })
        
      
        
        
        
    
    }

}
