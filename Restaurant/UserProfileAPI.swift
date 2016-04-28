//
//  UserProfileAPI.swift
//  Restaurant
//
//  Created by user on 3/19/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserProfileAPI:API{
    
    init(){
        super.init(Authorization: "", ContentType: "")
        
    }
    
    init(author :String, content :String){
        super.init(Authorization: author, ContentType: content)
    }
    func loadImageData(url_image: String) -> NSData?{
        var imageData : NSData?
        Alamofire.request(.GET, url_image).responseData{ response in
            print(response.result)
            if response.result.isSuccess {
                imageData = response.result.value
            }
            
        }
        return imageData
    }
    func loadOrderList(completion: (([Order]) -> Void)!){
        // .Get Menu of Restaurant
        let urlString = "http://beta.json-generator.com/api/json/get/N1VBV-22x"
        //let urlString = "http://54.200.145.4:1200/menu/\(self.res_id)"
        
        
        Alamofire.request(.GET, urlString).responseJSON(completionHandler: { response in
            
            let json = JSON(response.result.value!)
            var orderList = [Order]()
            for var i=0; i<json.count; i++ {
                let order = Order(json:json[i])
                orderList.append(order)
                
            }
            completion(orderList)
        })
        
        
    }
    func postUserProfile(user:UserProfile?, completion:((Bool)) -> Void) {
        let urlString = "http://innovationknock.com:1200/user"
        if user != nil{
            Alamofire.request(.POST, urlString,parameters:user?.toDictionary()).responseJSON(completionHandler: {response in
                if response.result.isSuccess{
                    let json = JSON(response.result.value!)
                    print(json["status"].int)
                    print(json["detail"].string)
                    let status = json["status"].int
                    if status==1{
                        completion(true)
                    }
                    //completion(true)
                }else{
                    print("Send menu to cart fail::::")
                    debugPrint(response)
                    
                    //completion(true)
                }
                
            })
        }
        
    }
    func setRestaurantID(res_id : String)->Void{
        
    }
    
    
}