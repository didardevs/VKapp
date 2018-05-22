//
//  MyStructures.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 09/03/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import Foundation
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


class Friend : Object{
    @objc dynamic var id = 0
    @objc dynamic var friendFullName = ""
    @objc dynamic var friendPhoto = ""
    @objc dynamic var friendsFirstName = ""
    
    convenience init(json: JSON){
        self.init()
        self.id = json["id"].intValue
        self.friendFullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.friendPhoto = json["photo_100"].stringValue
        self.friendsFirstName = json["first_name"].stringValue
    }
    override static func primaryKey() -> String? { return "id" }
}
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
class VKFriendsPhoto{
    var id = 0
    var smallPhotoURL = ""
    var largePhotoURL = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.smallPhotoURL = json["photo_75"].stringValue
    }
}

class VKNewsFeed{
    var postId = 0
    var sourceId = 0
    var postTimeStamp : Double = 0.0
    var postOwner = ""
    var postText = ""
    var likesCount = 0.0
    var commentsCount = 0.0
    var repostCount = 0.0
    var viewersCount = 0.0
    var ownerIcon = ""
    var ownerPostId = 0
    var postImage = ""
    convenience init(json: JSON){
        self.init()
        
        self.postId = json["post_id"].intValue
        self.sourceId = json["source_id"].intValue
        self.postText = json["text"].stringValue
        self.postTimeStamp = json["date"].doubleValue
        self.likesCount = json["likes"]["count"].doubleValue
        self.commentsCount = json["comments"]["count"].doubleValue
        self.repostCount = json["reposts"]["count"].doubleValue
        self.viewersCount = json["views"]["count"].doubleValue
        self.postImage = json["attachments"][0]["photo"]["photo_604"].stringValue
    }
    convenience init(groupProfiles json: JSON) {
        self.init()
        ownerPostId = json["id"].intValue
        ownerIcon = json["photo_50"].stringValue
        postOwner = json["name"].stringValue
    }
    convenience init(friendProfiles json: JSON) {
        self.init()
        ownerPostId = json["id"].intValue
        ownerIcon = json["photo_50"].stringValue
        postOwner = json["first_name"].stringValue + " " + json["last_name"].stringValue
    }
}




class VKMessage {

    var conversationID = 0
    var userID = 0
    var messageDate : Double = 0.0
    var messageBody = ""
    var messageReadState = 0
    var unread = 0
    var friendID = 0
    var friendPhoto = ""
    var friendName = ""
    var currentUserMiniPhoto = ""
    
    convenience init(json: JSON) {
        self.init()
        conversationID = json["message"]["id"].intValue
        userID = json["message"]["user_id"].intValue
        messageDate = json["message"]["date"].doubleValue
        messageBody = json["message"]["body"].stringValue
        messageReadState = json["message"]["read_state"].intValue
        unread = json["message"]["read_state"].intValue
        friendPhoto = json["message"]["photo_100"].stringValue
        friendName = json["message"]["title"].stringValue
        
    }
    convenience init(jsonFriends json: JSON) {
        self.init()
        friendID = json["id"].intValue
        friendPhoto = json["photo_50"].stringValue
        friendName = json["first_name"].stringValue + " " + json["last_name"].stringValue
    }
    convenience init(jsonCurrentUser json: JSON) {
        self.init()
        currentUserMiniPhoto = json["photo_50"].stringValue
    }
}



