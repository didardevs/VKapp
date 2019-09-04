//
//  Realm.swift
//  VKapp
//
//  Created by Didar on 8/27/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import RealmSwift

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
                realm.add(friends, update: .modified)
                
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
