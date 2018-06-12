//
//  AppDelegate.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/12/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import UserNotifications
import WatchConnectivity
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var newsPost: Results<VKNewsFeed2>?
    var vkNewsFeed = [[String:String]]()
    var wcSession: WCSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            if granted == true {
                
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4235772458712584/7482421939")
        application.registerForRemoteNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let fetchFriendRequest = DispatchGroup()
        
        var timer: DispatchSourceTimer? = nil
        var lastUpdate: Date? {
            get {
                return UserDefaults.standard.object(forKey: "Last Update") as? Date
            }
            set {
                UserDefaults.standard.setValue(Date(), forKey: "Last Update")
            }
        }
        
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 30 {
            
            completionHandler(.noData)
            return
        }
        
        fetchFriendRequest.enter()
        VKServices.shared.getFriendRequests { requests, error in
            if  requests != nil {
                
                completionHandler(.newData)
                
                DispatchQueue.main.async {
                    application.applicationIconBadgeNumber =
                        userDefaults.integer(forKey: "requestsCount")
                }
            } else if !error.isEmpty {
                completionHandler(.failed)
            }
            fetchFriendRequest.leave()
        }
        
        fetchFriendRequest.notify(queue: DispatchQueue.main) {
            
            timer = nil
            lastUpdate = Date()
            completionHandler(.newData)
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now() + 29, leeway: .seconds(1))
        timer?.setEventHandler(handler: {
            
            fetchFriendRequest.suspend()
            
            completionHandler(.failed)
            return
        })
        timer?.resume()
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate: WCSessionDelegate{
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        syncNews()
        if message["request"] as? String == "VKnews" {
            replyHandler(["newsFeed": vkNewsFeed])
            
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    private func syncNews() {
        
        newsPost = RealmL.fetchData(object: VKNewsFeed2())
        vkNewsFeed.removeAll()
        
        for new in newsPost! {
            vkNewsFeed.append(["postOwner": new.postOwner,
                               "ownerIcon": new.ownerIcon,
                               "postText": new.postText,
                               "postImage": new.postImage
                ])
        }
    }
    
}

