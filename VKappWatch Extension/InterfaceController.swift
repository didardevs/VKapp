//
//  InterfaceController.swift
//  VKappWatch Extension
//
//  Created by Didar Naurzbayev on 6/6/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    var wsSession: WCSession?
    var vkPosts = [VKNewsFeed]()
    
    @IBOutlet var table: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            wsSession = WCSession.default
            wsSession?.delegate = self
            wsSession?.activate()
        }
    }
    func reloadTable(){
        table.setNumberOfRows(vkPosts.count, withRowType: "newsPost")
        for (index, post) in vkPosts.enumerated() {
            let row = table.rowController(at: index) as! NewsFeedRow
            row.ownerName.setText(post.postOwner)
            row.ownerText.setText(post.postOwner)
            
            
            
            self.getPhoto(photo: post.ownerIcon, completion: { (data) in
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    row.ownerIcon.setImage(image)
                }
            })
            let contentGroup: String = post.postImage
            var url: URL?
            if contentGroup != "" {
                url = URL(string: contentGroup)
            }
            if url != nil {
                URLSession.shared.dataTask(with: url!) { (data, response, errore) in
                    guard data != nil else {return}
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        row.postImage.setImage(image)
                    }
                    }.resume()
            }
            
        }
    }
    func getPhoto(photo: String,  completion: @escaping(Data) -> Void) {
        
        let url = URL(string: photo)
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            guard let data = data else {return}
            completion(data)
            
            }.resume()
    }
    
    private func fetchNews() {
        wsSession?.sendMessage(["request":"VKnews"],
                               replyHandler: { (reply) in
                                guard let vkNewsFeed = reply["newsFeed"] as? [[String:String]] else { return }
                                for news in vkNewsFeed {
                                    if let postOwner = news["postOwner"],
                                        let ownerIcon = news["ownerIcon"],
                                        let postText = news["postText"],
                                        let postImage = news["postImage"] {
                                        self.vkPosts.append(VKNewsFeed(postOwner: postOwner, ownerIcon: ownerIcon, postText: postText, postImage: postImage))
                                    }
                                }
                                self.reloadTable()
        },
                               errorHandler: { (error) in
                                print(error.localizedDescription)
        })
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}

extension InterfaceController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            fetchNews()
            reloadTable()
        } else {
            self.table.setRowTypes(["newsPost"])
            let row = self.table.rowController(at: 0) as! NewsFeedRow
            row.ownerText.setText("No connect!")
        }
    }
    
}

struct VKNewsFeed {
    var postOwner: String
    var ownerIcon: String
    var postText: String
    var postImage: String
    
    init(postOwner: String, ownerIcon: String, postText: String, postImage: String) {
        self.postOwner = postOwner
        self.ownerIcon = ownerIcon
        self.postText = postText
        self.postImage = postImage
    }
}
