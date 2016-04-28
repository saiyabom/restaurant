//
//  Util.swift
//  Restaurant
//
//  Created by user on 3/5/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
class Util {
    static func loadImage(imageURL:String,image:UIImageView){
        Alamofire.request(.GET, imageURL).response { request, response, data, error in
            image.image = UIImage(data: data!)
        }
    }
    static func getUserID() -> String?{
        let realm = try! Realm()
        let user = realm.objects(UserProfile)
        if !user[0].userId.isEmpty{
            return user[0].userId
        }
        return nil
    }
       static func getUserProfile() -> UserProfile?{
        let realm = try! Realm()
        let user = realm.objects(UserProfile)
        return user[0]
    }
    
}