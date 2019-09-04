//
//  VKServxices.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 07/03/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


class VKServices {
    static let shared = VKServices()

    let VKURL = "https://api.vk.com/method/"
    
    let accessToken = userDefaults.string(forKey: "token")
    typealias loadNewsDataCompletion = () -> Void
    let version = "5.73"
    
  
    func getMyFriends(){
        let path = "friends.get"
        
        let parameters: Parameters = [
                                      "order": "hints",
                                      "fields": "city, nickname, photo_200_orig",
                                      "name_case": "nom",
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = VKURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let friends = json["response"]["items"].compactMap{Friend(json: $0.1)}
            print(friends)
            Realm.addDataToRealm(friends)
            
        }
        
    }
    

    
    func userInfo(userID : String, completion: @escaping ([User]) ->Void){
        let path = "users.get"
        
        let parameters: Parameters = ["user_ids" : userID,
                                      "extended" : 1,
                                      "fields" : "first_name,last_name,sex,photo_50,photo_100,counters,status",
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = VKURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            let user = json["response"].compactMap{User(json: $0.1)}

            completion(user)
            
        }
        
    }
    func getFriendRequests(completion: @escaping (Int?, String) -> () ) {
        let path = "users.getFollowers"
        let userID = userDefaults.string(forKey: "userID")
        let parameters: Parameters = [
            "user_id" : userID!,
            "count": "100",
            "fields" : "photo_100",
            "extended": "1",
            "access_token": accessToken!,
            "v": version]
        let url = VKURL + path
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON(queue: .global()) { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let follower = json["response"]["items"].compactMap{Follower(json: $0.1)}
            
            let count = json["response"]["count"].intValue
            
            UserDefaults.standard.setValue(Date(), forKey: "Last Update")
            
            
            if userDefaults.integer(forKey: "requestsCount") > 0{
                VKNotification().postNotification()
            }
            
            completion(count, "voila")
            Realm.addRequestsToRealm(follower)
        }
        
    }
    
    
    func getAllPhotos(vkUserID : Int, completion: @escaping ([Photo]) ->Void){
        let path = "photos.getAll"
        
        let parameters: Parameters = ["owner_id" : vkUserID,
                                      "extended" : 1,
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = VKURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let friendPhotos = json["response"]["items"].compactMap{Photo(json: $0.1)}
            DispatchQueue.main.async{
                completion(friendPhotos)
            }
        }
    }
    
    
    
    func timeStringFromUnixTime(unixTime: Double) -> String{
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}




