//
//  AppNotifications.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 5/17/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//


import Foundation
import UserNotifications

class VKNotification {
    let content = UNMutableNotificationContent()
    
    func postNotification() {
        
        let ace = userDefaults.integer(forKey: "requestsCount")
        content.title = ""
        content.body = "You have \(ace) new follower(s)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIndentifier = "friend"
        let request = UNNotificationRequest(identifier: requestIndentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIndentifier])
        })
        
    }
}
