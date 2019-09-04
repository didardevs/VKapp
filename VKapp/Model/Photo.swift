//
//  Photo.swift
//  VKapp
//
//  Created by Didar on 8/26/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Photo{
    var id = 0
    var smallPhotoURL = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.smallPhotoURL = json["photo_604"].stringValue
    }
}
