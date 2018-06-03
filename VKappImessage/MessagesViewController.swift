//
//  MessagesViewController.swift
//  VKappImessage
//
//  Created by Didar Naurzbayev on 5/29/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import Messages
import SDWebImage

class MessagesViewController: MSMessagesAppViewController {
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
    

    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {

    }
    
    override func didResignActive(with conversation: MSConversation) {
        
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
       
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
       
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
       
    }

}


extension MessagesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vkNewsfeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        
        let newsfeed = vkNewsfeeds[indexPath.row]
        print(newsfeed)
        cell.nameLabel.text = newsfeed.postOwner
        cell.postTextLabel.text = newsfeed.postText
        cell.imageV.sd_setImage(with: URL(string:newsfeed.ownerIcon))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = vkNewsfeeds[indexPath.row]
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        layout.caption = post.postText
 
        layout.imageTitle = post.postOwner
        let image = post.postImage
        if image != "" {
            let url = URL(string: image)
            let data = try? Data(contentsOf: url!)
            layout.image = UIImage(data: data!)
        }
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
}
