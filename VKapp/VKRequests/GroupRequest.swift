//
//  GroupRequest.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/12/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class GroupRequests{
    let vkURL = "https://api.vk.com/method/"
    
    let accessToken = userDefaults.string(forKey: "token")
    let applicationID = 1234
    let version = "5.73"
    
    func searchGroups(q : String, completion: @escaping ([Group]) ->Void){
        let path = "groups.search"
        
        let parameters: Parameters = ["q" : q,
                                      "extended" : 1,
                                      "fields" : "members_count, type",
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let searchingGroups = json["response"]["items"].compactMap{Group(json: $0.1)}
            
            DispatchQueue.global().async{
                completion(searchingGroups)
            }
        }
    }
    
    func getMyGroups(vkUserID : String){
        let path = "groups.get"
        
        let parameters: Parameters = ["user_id" : vkUserID,
                                      "extended" : 1,
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let groups = json["response"]["items"].compactMap{Group(json: $0.1)}
            
            Realm.addDataToRealm(groups)
            
        }
    }
    
    func leaveGroup(groupID: Int) {
        let path = "groups.leave"
        
        let parameters: Parameters = ["group_id" : groupID,
                                      "extended" : 1,
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInteractive)) { response in
            
        }
    }
    
    
    func joinGroup(groupID: Int) {
        let path = "groups.join"
        
        let parameters: Parameters = ["group_id" : groupID,
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
        }
    }
    
}
