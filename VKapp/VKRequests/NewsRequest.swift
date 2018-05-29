//
//  NewsRequest.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/17/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import Alamofire
import SwiftyJSON

class GetNews{
    let userID = UserDefaults.standard.string(forKey: "userID")
    let vkURL = "https://api.vk.com/method/"
    static let shared = GetNews()
    let accessToken = UserDefaults.standard.string(forKey: "token")
    typealias loadNewsDataCompletion = () -> Void
    let version = "5.73"
    
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

