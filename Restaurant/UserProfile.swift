//
//  UserProfile.swift
//  Restaurant
//
//  Created by user on 3/5/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import RealmSwift

class UserProfile: Object {
    //static let sharedInstance = UserProfile()
    dynamic var id = 0
    dynamic var Authorization = ""
    dynamic var ContentType = ""
    
    dynamic var userId = ""
    dynamic var firstName = ""
    dynamic var lastName = ""


    
    dynamic var imageofUser :NSData? = nil
    dynamic var createdAt = NSDate()
    
    
    override static func primaryKey() -> String{
        return "id"
    }
    
    func toDictionary()-> Dictionary<String,String>{
        return [
            "user_id": self.userId,
            "name": "\(self.firstName) \(self.lastName)",
        ]
    }
    
    
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

