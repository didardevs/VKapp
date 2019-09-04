//
//  User.swift
//  VKapp
//
//  Created by Didar on 8/26/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class User{
    var fullName = ""
    var status = ""
    var counters = [String: Int]()
    
    var userImage = ""
    
    convenience init (json: JSON){
        self.init()
        fullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
        status = json["status"].stringValue
        let countersJson = json["counters"].dictionaryValue
        userImage = json["photo_100"].stringValue
        for elem in countersJson {
            self.counters[elem.key] = elem.value.intValue
        }
    }
}
