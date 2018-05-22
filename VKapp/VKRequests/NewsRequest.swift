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
    let vkURL = "https://api.vk.com/method/"
    
    let accessToken = userDefaults.string(forKey: "token")
    let applicationID = 1234
    let version = "5.73"
    
    
    func getAllNews(completion: @escaping ([VKNewsFeed]) ->Void){
        let path = "newsfeed.get"
        
        let parameters: Parameters = ["filters" : "post,photo,wall_photo",
                                      "count" : 200,
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let newsfeed = json["response"]["items"].compactMap{VKNewsFeed(json: $0.1)}
            print(newsfeed)
            
            DispatchQueue.global().async{
                
                completion(newsfeed)
            }
        }
    }
}

private func addProfiles(from json: JSON?, to news: VKNewsFeed) {
    let profilesArr = json!["response", "profiles"]
    
    
    for (_, i) in profilesArr {
        if i["id"].intValue == news.sourceId {
            news.postOwner = i["first_name"].stringValue + " " + i["last_name"].stringValue
            news.ownerIcon = i["photo_100"].stringValue
        }
    }
}

private func addGroups(from json: JSON?, to news: VKNewsFeed) {
    let groupsArr = json!["response", "groups"]
    
    for (_, ii) in groupsArr {
        if ii["id"].intValue == -news.sourceId {
            news.postOwner = ii["name"].stringValue
            news.ownerIcon = ii["photo_100"].stringValue
        }
    }
}
