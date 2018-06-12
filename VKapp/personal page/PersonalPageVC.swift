//
//  PersonalPageVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 6/9/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import SDWebImage

class PersonalPageVC: UIViewController {
    
    @IBOutlet weak var fullname: UILabel!
    
    @IBOutlet weak var yearPlace: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var groupCount: UILabel!
    
    @IBOutlet weak var friendCount: UILabel!
    
    var vkService = VKServices()
    
    let vkuseid = userDefaults.string(forKey: "userID")
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkService.userInfo(vkUserID: vkuseid!) { [weak self] userArray in
            if userArray.count > 0 {
                let user = userArray[0]
                self?.fullname.text = user.fullName
                self?.yearPlace.text = user.status
                if user.userImage != ""{
                    self?.image.sd_setImage(with: URL(string:user.userImage))
                }
                let friendNum = self?.getStringProperty(property: user.counters["friends"])
                let groupNum = self?.getStringProperty(property: user.counters["groups"])
                
                self?.groupCount.text = groupNum
                self?.friendCount.text = friendNum
            }
        }
    }
    
    
    
    func getStringProperty(property: Int?) -> String {
        if let intProperty = property {
            return String(intProperty)
        } else {
            return ""
        }
    }
    
}


