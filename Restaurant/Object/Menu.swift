//
//  Menu.swift
//  Restaurant
//
//  Created by user on 2/22/16.
//  Copyright © 2016 Imsi. All rights reserved.
//


import Foundation
import SwiftyJSON


class Menu {
    var menu_id : String?
    var menu_name: String?
    var menu_cost: Int?
    var menu_image_url: String?
    var restaurant_id: String?
    var menu_desc :String?
    var isVisibled :Bool?
    var delivery_cost:String?
    enum StatusOfMenu{
        case inList
        case inCart
    }
    var status : StatusOfMenu = StatusOfMenu.inList
    var menu_number:Int?

    init(json: JSON,cost:String){
        
        if json["_id"].exists(){
            self.menu_id = json["_id"].string
        }else{
            self.menu_id = json["menu_id"].string
        }
        //self.menu_id = json["_id"].string
        if json["name"].exists(){
            self.menu_name = json["name"].string
        }else{
            self.menu_name = json["menu_name"].string
        }
        if json["price"].exists(){
            self.menu_cost = Int(json["price"].string!)
        }
        else{
           self.menu_cost = Int(json["menu_price"].string!)
        }
        if json["pic"].exists(){
            self.menu_image_url = json["pic"].string
        }else{
            self.menu_image_url = json["menu_pic"].string
        }
        if json["menu_des"].exists(){
             self.menu_desc = json["menu_des"].string
        }else{
            self.menu_desc = ""
        }
        if json["res_id"].exists(){
            self.restaurant_id = json["res_id"].string
        }else{
            self.restaurant_id = ""
        }
        
        
    
        if json["menu_number"].exists(){
            let number = json["menu_number"].int!
            if number != 0{
                self.menu_number = number
                checkStatusofMenu()
            }else {
                self.menu_number = 0
            }
        }else if json["menu_num"].exists(){
            
            let number = json["menu_num"].int!
            if number != 0 {
                self.menu_number = number
                self.checkStatusofMenu()
            }
        }
        self.isVisibled = true
        self.delivery_cost = cost
        
    }
    func toggleVisible(){
        if self.isVisibled!{
            self.isVisibled = false
        }
        else{
            self.isVisibled = true
        }
    }
    func getDictionary()->NSDictionary{
        let dict:NSDictionary = [
            /*"type" :"menu",
            "isVisibled": self.isVisibled!,
            "menu_name" : self.menu_name!,
            "menu_cost" : self.menu_cost!,
            "menu_number" : String(self.menu_number),
            "menu_desc" : "ADFDFAASD"*/
            "additionalRows" : 0,
            "cellIdentifier" : "OrderSubCell",
            "isExpandable" : false,
            "isExpanded" : false,
            "isVisible" : false,
            "menu_name" : self.menu_name!,
            "menu_cost" : self.menu_cost!,
            "menu_number" : self.menu_number!,
            "menu_desc" : "ADFDFAASD"

            
        ]
        return dict
    }
    func checkStatusofMenu(){
        if self.menu_number > 0{
            setMenuInCart()
        }else{
            setMenuInList()
        }
    }
    func setMenuInCart(){
        self.status = StatusOfMenu.inCart
    }
    func setMenuInList(){
        self.status = StatusOfMenu.inList
    }
    func isInCart()->Bool{
        if (status == StatusOfMenu.inCart) && (self.menu_number != 0) {
            return true
        }
        return false
    }
    func getTotalCostofFood()->Int{
        if isInCart(){
            return self.menu_number! * self.menu_cost!
        }else{
            setMenuInList()
            return 0
        }
        
    }
}
