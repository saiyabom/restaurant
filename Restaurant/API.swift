//
//  API.swift
//  Restaurant
//
//  Created by user on 3/5/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


class API{
    var headers = [
        "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
    init(Authorization author:String, ContentType content:String){
        self.headers["Authorization"] = author
        self.headers["Content-Type"] = content
    }
    
    
}