//
//  Order.swift
//  Restaurant
//
//  Created by user on 3/7/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON


class Order{
    enum OrderStatus{
        case inProgress
        case deliver
        case finished
    }
    let order_id : String?
    let order_restaurant_name :String?
    let order_detail : String?
    let order_total_cost : Int?
    let order_created_at : NSDate?
    let json:JSON?
    //let order_created_time : NS
    let menu_list :[Menu]?
    init(json:JSON){
        self.json = json
        order_id = json["order_id"].string
        order_restaurant_name = json["order_restaurant_name"].string
        order_detail = json["order_detail"].string
        order_total_cost = json["order_total_cost"].int
        
        //format date from json "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        order_created_at = json["order_created_at"].string?.toDateTime()
        menu_list = [Menu]()
        let data = json["data"].array
        for var i=0; i<data?.count; i++ {
            let menuItem = Menu(json: data![i],cost:"0")
            self.menu_list?.append(menuItem)
            
        }
        
    }
    func getMenuNumber()->Int{
        return (self.menu_list?.count)!
    }
    func getDictionaray()->NSDictionary{
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let create_date = dateFormatter.stringFromDate(self.order_created_at!)
        dateFormatter.dateFormat = "HH:mm"
        let create_time = dateFormatter.stringFromDate(self.order_created_at!)
        /*let dict : NSDictionary = [
            "type":"order",
            "isVisibled":true,
            "restaurant_name" : self.order_restaurant_name!,
            "created_at_date" : create_date,
            "created_at_time" : create_time,
            "cost": self.order_total_cost!
        ]*/
        let dict :NSDictionary = [
            "additionalRows" : (self.menu_list?.count)!,
            "cellIdentifier" : "OrderMainCell",
            "isExpandable" : true,
            "isExpanded" : false,
            "isVisible" : true,
            "restaurant_name" : self.order_restaurant_name!,
            "created_at_date" : create_date,
            "created_at_time" : create_time,
            "cost": self.order_total_cost!
            
        ]
        //debugPrint(dict)
        return dict
    }
    
    func toggleMenusVisibled(){
        for var i=0; i<self.menu_list?.count; i++ {
            self.menu_list![i].toggleVisible()
        }
    }
    
}
extension String
{
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        
        //Return Parsed Date
        return dateFromString
    }
}
