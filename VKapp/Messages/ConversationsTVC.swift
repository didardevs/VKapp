//
//  ConversationsTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/12/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//
import UIKit
import SDWebImage
import RealmSwift

class ConversationsTVC: UITableViewController {
    let vkService = VKServices()
    var vkMessages = [VKMessage]()
    let vkUserId = userDefaults.string(forKey: "userID")
    var friendVK: Results<Friend>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkService.getMyFriends(vkUserID : vkUserId!)
        vkService.getMyMessages() {[weak self] vkMessages in
            self?.vkMessages = vkMessages
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vkMessages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationID", for: indexPath) as! ConverstationsCell
        let chatVK = vkMessages[indexPath.row]
        
        
        cell.personName.text = chatVK.friendName
        cell.personPhoto.sd_setImage(with: URL(string: chatVK.friendPhoto))
        cell.messageDate.text = vkService.timeStringFromUnixTime(unixTime: chatVK.messageDate)
        cell.messageLabel.text = chatVK.messageBody
        cell.messageIconLast.sd_setImage(with: URL(string: chatVK.currentUserMiniPhoto))
        
        cell.messageIconLast.layer.cornerRadius = cell.messageIconLast.frame.height / 2
        cell.personPhoto.layer.cornerRadius = cell.personPhoto.frame.height / 2
        
        
        
        return cell
    }
    
}
