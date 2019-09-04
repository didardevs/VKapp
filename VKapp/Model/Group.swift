//
//  Group.swift
//  VKapp
//
//  Created by Didar on 8/26/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Group: Object{
    @objc dynamic var id = 0
    @objc dynamic var groupName = ""
    @objc dynamic var groupPhoto = ""
    @objc dynamic var memberCount = ""
    @objc dynamic var groupType = ""
    convenience init(json: JSON){
        self.init()
        self.id = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.groupPhoto = json["photo_100"].stringValue
        self.memberCount = json["members_count"].stringValue
        self.groupType = json["type"].stringValue
    }
    override static func primaryKey() -> String? { return "id" }
}
