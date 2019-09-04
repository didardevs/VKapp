//
//  Follower.swift
//  VKapp
//
//  Created by Didar on 8/26/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Follower : Object{
    @objc dynamic var id = 0
    @objc dynamic var friendFullName = ""
    
    convenience init(json: JSON){
        self.init()
        self.id = json["id"].intValue
        self.friendFullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
    }
    override static func primaryKey() -> String? { return "id" }
}
