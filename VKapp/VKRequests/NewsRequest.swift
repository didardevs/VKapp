//
//  NewsRequest.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/17/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

class GetNews{
    let userID = UserDefaults.standard.string(forKey: "userID")
    let vkURL = "https://api.vk.com/method/"
    static let shared = GetNews()
    let token = UserDefaults.standard.string(forKey: "token")
    typealias loadNewsDataCompletion = () -> Void
    let version = "5.73"
    var friends = [Friend]()
    var groups = [Group]()
    
    func getAllNews(countN: Int = 200, accessToken: String ,completion: @escaping ([VKNewsFeed]) ->Void){
        let path = "newsfeed.get"
        
        let parameters: Parameters = ["filters" : "post",
                                      "count" : countN,
                                      "access_token" : accessToken,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let newsfeed = json["response"]["items"].compactMap{VKNewsFeed(json: $0.1)}
            let newsfeed1 = json["response"]["groups"].compactMap{VKNewsFeed(groupProfiles: $0.1)}
            let newsfeed2 = json["response"]["profiles"].compactMap { VKNewsFeed(friendProfiles: $0.1) }
            
            for i in 0..<newsfeed.count{
                if newsfeed[i].sourceId < 0 {
                    for id in 0..<newsfeed1.count {
                        if newsfeed[i].sourceId * -1 == newsfeed1[id].ownerPostId {
                            newsfeed[i].ownerPostId = newsfeed1[id].ownerPostId
                            newsfeed[i].postOwner = newsfeed1[id].postOwner
                            newsfeed[i].ownerIcon = newsfeed1[id].ownerIcon
                        }
                    }
                    
                } else {
                    for id in 0..<newsfeed2.count {
                        newsfeed[i].ownerPostId = newsfeed2[id].ownerPostId
                        newsfeed[i].postOwner = newsfeed2[id].postOwner
                        newsfeed[i].ownerIcon = newsfeed2[id].ownerIcon
                    }
                    
                }
            }
            
            DispatchQueue.global().async{
                
                completion(newsfeed)
            }
        }
    }
    
    func newVkPost(message: String, latitude: Double?, longitude: Double?, completion: @escaping () -> Void) {
        let myParameters: Parameters = [
            "message" : message,
            "lat" : latitude ?? 0,
            "long" : longitude ?? 0,
            "v" : version,
            "access_token" : token!
        ]
        let postUrl = "https://api.vk.com/method/wall.post"
        
        Alamofire.request(postUrl, parameters: myParameters).responseJSON(completionHandler: { response in
            completion()
        })
    }
    
    func getAllPosts(countN: Int = 200){
        let path = "newsfeed.get"
        
        let parameters: Parameters = ["filters" : "post",
                                      "count" : countN,
                                      "access_token" : token!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let newsfeed = json["response"]["items"].compactMap{VKNewsFeed2(json: $0.1)}
            self.groups = json["response"]["groups"].compactMap{Group(json: $0.1)}
            self.friends = json["response"]["profiles"].compactMap{Friend(json: $0.1) }
            
            self.saveNewsData(news: newsfeed)
        }
    }
    func saveNewsData( news: [VKNewsFeed2]) {
        
        do{
            let realm = try Realm()
            let oldNews = realm.objects(VKNewsFeed2.self)
            for i in news {
                let numberId = abs(i.sourceId)
                if postOwnerIdentifier(sourceId: numberId) {
                    for userF in friends {
                        if numberId == userF.id {
                            i.postOwner = userF.friendFullName
                            i.ownerIcon = userF.friendPhoto
                            break
                        }
                    }
                }
                else {
                    for group in groups {
                        if numberId == group.id {
                            i.postOwner = group.groupName
                            i.ownerIcon = group.groupPhoto
                            break
                        }
                    }
                }
            }
            
            realm.beginWrite()
            realm.delete(oldNews)
            
            realm.add(news)
            try realm.commitWrite()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    func postOwnerIdentifier(sourceId: Int) -> Bool {
        
        for i in friends {
            if i.id == abs(sourceId){
                return true
            }
        }
        return false
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

class VKNewsFeed2 : Object{
    @objc dynamic var postId = 0
    @objc dynamic var sourceId = 0
    @objc dynamic var postTimeStamp : Double = 0.0
    @objc dynamic var postOwner = ""
    @objc dynamic var postText = ""
    @objc dynamic var likesCount = 0.0
    @objc dynamic var commentsCount = 0.0
    @objc dynamic var repostCount = 0.0
    @objc dynamic var viewersCount = 0.0
    @objc dynamic var ownerIcon = ""
    @objc dynamic var ownerPostId = 0
    @objc dynamic var postImage = ""
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
    override static func primaryKey() -> String? { return "postId" }
}

class RealmL {
    
    static func fetchData<T: Object> (object: T) -> Results<T> {
        var result: Results<T>?
        do {
            let realm = try Realm()
            result = realm.objects(T.self)
        } catch {
            print(error.localizedDescription)
        }
        return result!
    }
}
