//
//  TodayViewController.swift
//  VKappToday
//
//  Created by Didar Naurzbayev on 5/28/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import NotificationCenter
import SDWebImage

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    let token = UserDefaults(suiteName: "group.vkappGroup")?.string(forKey: "AccessToken")
    
    var vkService = GetNews()
    var vkNewsfeeds = [VKNewsFeed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        vkService.getAllNews(countN: 20, accessToken: token!) {[weak self] vkNewsfeeds in
            self?.vkNewsfeeds = vkNewsfeeds
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vkNewsfeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayViewCell
        
        let newsfeed = vkNewsfeeds[indexPath.row]
        cell.cellText.text = newsfeed.postText
        cell.cellImage.sd_setImage(with: URL(string:newsfeed.ownerIcon))
        
        return cell
    }
}
