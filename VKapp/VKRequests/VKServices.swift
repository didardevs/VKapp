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
    let userID = userDefaults.string(forKey: "userID")
    let vkURL = "https://api.vk.com/method/"
    static let shared = VKServices()
    let accessToken = userDefaults.string(forKey: "token")
    typealias loadNewsDataCompletion = () -> Void
    let version = "5.73"
    
    
    
    func getMyFriends(vkUserID : String){
        let path = "friends.get"
        
        let parameters: Parameters = ["user_id" : vkUserID,
                                      "extended" : 1,
                                      "fields" : "photo_100",
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let friends = json["response"]["items"].compactMap{Friend(json: $0.1)}
            Realm.addDataToRealm(friends)
            
        }
        
    }
    
    
    func userInfo(vkUserID : String, completion: @escaping ([PersonalModel]) ->Void){
        let path = "users.get"
        
        let parameters: Parameters = ["user_id" : vkUserID,
                                      "extended" : 1,
                                      "fields" : "first_name,last_name,sex,photo_50,photo_100,counters,status",
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let user = json["response"].compactMap{PersonalModel(json: $0.1)}
            completion(user)
            
        }
        
    }
    func getFriendRequests(completion: @escaping (Int?, String) -> () ) {
        let path = "users.getFollowers"
        let parameters: Parameters = [
            "user_id" : userID!,
            "count": "100",
            "fields" : "photo_100",
            "extended": "1",
            "access_token": accessToken!,
            "v": version]
        let url = vkURL + path
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
    
    
    func getAllPhotos(vkUserID : Int, completion: @escaping ([VKFriendsPhoto]) ->Void){
        let path = "photos.getAll"
        
        let parameters: Parameters = ["owner_id" : vkUserID,
                                      "extended" : 1,
                                      "access_token" : accessToken!,
                                      "v" : version]
        let url = vkURL + path
        Alamofire.request(url, method: .get, parameters : parameters).responseJSON { response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            let friendPhotos = json["response"]["items"].compactMap{VKFriendsPhoto(json: $0.1)}
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


extension Realm{
    static func addDataToRealm<T: Object>(_ object: [T]){
        do{
            let realm = try Realm()
            
            let oldRealmObject = realm.objects(T.self)
            
            try realm.write{
                let counter = object.count - oldRealmObject.count
                userDefaults.set(counter, forKey: "newgroupCount")
                realm.delete(oldRealmObject)
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    static func newDataToRealm<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects)
            }
        } catch {
            print(error)
        }
    }
    static func writeNewFriendsToRealm(_ friends: [Friend]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(friends, update: true)
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    static func deleteDataFromRealm<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error)
        }
    }
    static func addRequestsToRealm<T: Object>(_ object: [T]){
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL!)
            let oldRealmObject = realm.objects(T.self)
            
            try realm.write{
                let counter = object.count - oldRealmObject.count
                
                userDefaults.set(counter, forKey: "requestsCount")
                realm.delete(oldRealmObject)
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
}


