//
//  CartAPI.swift
//  Restaurant
//
//  Created by user on 3/5/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CartAPI:API{
    //let urlstring = "http://requestb.in/1dk9fto1"
    var user_id: String?
    init(user_id: String){
        self.user_id = user_id
        super.init(Authorization: "", ContentType: "")
    }
    
    init(author :String, content :String){
        super.init(Authorization: author, ContentType: content)
    }
    func loadItemsInCart(completion: ([Menu]) -> Void){
        // .Get Menu of Restaurant
        let urlString = "http://innovationknock.com:1200/order/preorder/\(self.user_id!)"
        
        
        
        Alamofire.request(.GET, urlString).responseJSON(completionHandler: { response in

            let jsonAbc = JSON(response.result.value!)
            var menusInCart = [Menu]()
            if jsonAbc["data"].exists() && jsonAbc["status"].int == 1 {
                let data = jsonAbc["data"][0]["order_menu"]["menu"].array
                let delivery_cost = jsonAbc["data"][0]["order_cost_service"].string
                
                debugPrint("json in cart: \(data![0])")
                
                
                for var i=0; i<data!.count; i++ {
                    let item = Menu(json: data![i],cost:delivery_cost!)
                    menusInCart.append(item)
                    debugPrint(menusInCart)
                    
                }
                
                completion(menusInCart)
            }
        })
        
        
    }
    
}