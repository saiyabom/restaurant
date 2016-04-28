//
//  MenutoCartAPI.swift
//  Restaurant
//
//  Created by user on 3/5/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class MenutoCartAPI:API{
    
    
    //let urlstring = "http://requestb.in/1dk9fto1"
    let urlstring = "http://innovationknock.com:1200/order/preorder/menu"
    //var user_id : String?
    init(){
        super.init(Authorization: "", ContentType: "")
    }

    init(author :String, content :String){
        super.init(Authorization: author, ContentType: content)
        
    }
    func postMenuToCart(user_id:String,menu:Menu,number:Int,des:String,completion:((Bool))->Void){
        
        
        let parameter = [
            "user_id": user_id,
            "email": "",
            "menu_id": menu.menu_id!,
            "menu_num": number,
            "menu_des": des,
            "res_id": menu.restaurant_id!,
            "order_cost_service":menu.delivery_cost!
        ]
        debugPrint(parameter)
        
        Alamofire.request(.POST, urlstring,parameters:parameter as! [String:AnyObject]).responseJSON(completionHandler: {response in
            if response.result.isSuccess{
                let json = JSON(response.result.value!)
                print(json["status"].int)
                print(json["detail"].string)
                let status = json["status"].int
                if status==1{
                    completion(true)
                }
                else if status==0{
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
    func loadCart(completion: (([Menu]) -> Void)!){
        Alamofire.request(.GET, urlstring).responseJSON(completionHandler: { response in
            let json = JSON(response.result.value!)
            //print("Data:Alamofire \(jsonValue)")
            //let json = JSON(data: data!)
            
            var menus = [Menu]()
            let data = json["data"].array
            
            for var i=0; i<data?.count; i++ {
                let menu = Menu(json: data![i],cost:"0")
                menus.append(menu)
            }
            completion(menus)
        })

    }
    
    func postConfirmPreorder(location:String, phone:String, completion:((Bool))->Void){
        let url_confirm = "http://innovationknock.com:1200/order/confirm"

        let parameter = [
            "location":location,
            "phone": phone
        ]
        debugPrint(parameter)
        
        Alamofire.request(.POST, url_confirm,parameters:parameter).responseJSON(completionHandler: {response in
            if response.result.isSuccess{
                let json = JSON(response.result.value!)
                print(json["status"].int)
                print(json["detail"].string)
                //print(json["number"].string)
                let status = json["status"].int
                if status==1{
                    completion(true)
                }
                else if status==0{
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