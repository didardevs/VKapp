//
//  FirebaseStruct.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/16/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftyJSON

class FirebaseService{
    let userID = userDefaults.string(forKey: "userID")
    let ref = Database.database().reference()
    
    func saveUserToFB(userID : String){
        let userID = userID
        let value = ["ID": userID]
        ref.child("users/Identity").updateChildValues(value)
        
    }
    
    func saveUsersGroups(group: Group){
        let groupId = String(group.id)
        let groupName = group.groupName
        let groupToSave = ["group_Name" : groupName, "groupID": groupId] as [String: Any]
        let dataRef = ref.child("users/Identity/\(userID!)/groups").childByAutoId()
        dataRef.setValue(groupToSave)
    }
    
}
