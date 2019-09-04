//
//  MainTabVC.swift
//  VKapp
//
//  Created by Didar on 8/25/19.
//  Copyright © 2019 Didar Naurzbayev. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    let dot = UIView()
    var isInitialLoad: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureViewControllers()
    }
    
    func configureViewControllers() {
        
        // home feed controller
        let feedVC = constructNavController(unselectedImage: UIImage(named: "feed")!, selectedImage: UIImage(named: "feed")!, rootViewController: NewsVTC())
        
        // search feed controller
        let searchVC = constructNavController(unselectedImage: UIImage(named: "friends")!, selectedImage: UIImage(named: "friends")!, rootViewController: FriendsTVC())
        
        // notification controller
        let notificationVC = constructNavController(unselectedImage: UIImage(named: "groups")!, selectedImage: UIImage(named: "groups")!, rootViewController: GroupsTableView())
        
        // profile controller
        let userProfileVC = constructNavController(unselectedImage: UIImage(named: "businessman")!, selectedImage: UIImage(named: "businessman")!, rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // view controllers to be added to tab controller
        viewControllers = [feedVC, searchVC, notificationVC, userProfileVC]
        
        // tab bar tint color
        tabBar.tintColor = .black
    }
    
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.tintColor = .black
        
        // return nav controller
        return navController
    }
    
    
    func configureNotificationDot() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            let tabBarHeight = tabBar.frame.height
            
            if UIScreen.main.nativeBounds.height == 2436 {
                // configure dot for iphone x
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - tabBarHeight, width: 6, height: 6)
            } else {
                // configure dot for other phone models
                dot.frame = CGRect(x: view.frame.width / 5 * 3, y: view.frame.height - 16, width: 6, height: 6)
            }
            
            // create dot
            dot.center.x = (view.frame.width / 5 * 3 + (view.frame.width / 5) / 2)
            dot.backgroundColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
            dot.layer.cornerRadius = dot.frame.width / 2
            self.view.addSubview(dot)
            dot.isHidden = true
        }
    }
    
    
}

