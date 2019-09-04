//
//  Friend.swift
//  VKapp
//
//  Created by Didar on 8/26/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friend : Object{
    @objc dynamic var id = 0
    @objc dynamic var friendFullName = ""
    @objc dynamic var friendPhoto = ""
    @objc dynamic var friendsFirstName = ""
    @objc dynamic var friendsCount = ""
    @objc dynamic var groupsCount = ""
    convenience init(json: JSON){
        self.init()
        self.id = json["id"].intValue
        self.friendFullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.friendPhoto = json["photo_200_orig"].stringValue
        self.friendsFirstName = json["first_name"].stringValue
        self.friendsCount = json["counters"]["friends"].stringValue
        self.groupsCount = json["counters"]["groups"].stringValue
    }
    override static func primaryKey() -> String? { return "id" }
}
