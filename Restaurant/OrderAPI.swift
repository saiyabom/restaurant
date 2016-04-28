//
//  OrderAPI.swift
//  Restaurant
//
//  Created by user on 3/7/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderAPI:API{
   
    init(){
        super.init(Authorization: "", ContentType: "")
        
    }
    
    init(author :String, content :String){
        super.init(Authorization: author, ContentType: content)
    }
    func loadOrderList(completion: (([Order]) -> Void)!){
        // .Get Menu of Restaurant
        // http://innovationknock.com:1200/order/1035070373206054
        
        let urlString = "http://innovationknock.com:1200/order/"
        //let urlString = "http://54.200.145.4:1200/menu/\(self.res_id)"
        
        
        Alamofire.request(.GET, urlString).responseJSON(completionHandler: { response in
            
            let json = JSON(response.result.value!)
            var orderList = [Order]()
            if json.count > 0{
                
                for var i=0; i<json.count; i++ {
                    let order = Order(json:json[i])
                    orderList.append(order)
                    
                }
                
            }
            completion(orderList)
           
            
            
        })
        
        
    }
    func setRestaurantID(res_id : String)->Void{
        
    }

    
}