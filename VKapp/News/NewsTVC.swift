//
//  NewsTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 3/26/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTVC: UITableViewController {
    
    var vkService = GetNews()
    var vkNewsfeeds: Results<VKNewsFeed2>?
    var notifToken: NotificationToken?
    var heightCache: [IndexPath : CGFloat] = [:]
    let accessToken = UserDefaults.standard.string(forKey: "token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        
        tableAndRealmUpdate()
        vkService.getAllPosts()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vkNewsfeeds?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsID", for: indexPath) as! NewsTVCell
        
        let newsfeed = vkNewsfeeds![indexPath.row]
        cell.iconImage.sd_setImage(with: URL(string:newsfeed.ownerIcon))
        cell.postImage.sd_setImage(with: URL(string:newsfeed.postImage))
        cell.nameLabel.text = newsfeed.postOwner
        cell.timeStamp.text = timeStringFromUnixTime(unixTime: newsfeed.postTimeStamp)
        cell.postTextLabel.text = newsfeed.postText
        cell.likesLabel.text = divideByK(number: newsfeed.likesCount)
        cell.commentsLabel.text = divideByK(number: newsfeed.commentsCount)
        cell.sharesLabel.text = divideByK(number: newsfeed.repostCount)
        cell.viewersLabel.text = divideByK(number: newsfeed.viewersCount)
        
        
        return cell
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
    
    func divideByK(number: Double) -> String {
        switch number{
        case _ where number < 1000: return String(format: "%.0f", number)
        case _ where number >= 1000 && number <= 1099: return "1K"
        case _ where number > 1100 && number < 9999: return String(format: "%.1f",(number/1000)) + "K"
        case _ where number > 10000 && number < 99999: return String(format: "%.1f",(number/10000)) + "K"
        default:
            return String(format: "%.1f", number)
        }
    }
    
    func navigationBarSetUp(){
        self.navigationItem.title = "Новости"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = heightCache[indexPath] else { return 400 }
        
        return height
    }
    
    
    func tableAndRealmUpdate(){
        guard let realm = try? Realm() else {return}
        vkNewsfeeds = realm.objects(VKNewsFeed2.self)
        notifToken = vkNewsfeeds?.observe {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            switch changes{
            case .initial:
                tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertion, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertion.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    
    
}

extension NewsTVC: NewsTVCellHeightDelegate{
    func setCellHeight(_ height: CGFloat,_ index: IndexPath){
        heightCache[index] = height
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
}
