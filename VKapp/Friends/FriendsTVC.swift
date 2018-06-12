//
//  FriendsTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 26/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTVC: UITableViewController {
    
    var vkService = VKServices()
    let vkUserId = userDefaults.string(forKey: "userID")
    var friendVK: Results<Friend>?
    var notifToken: NotificationToken?
    
    
    let queueForImage: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        tableAndRealmUpdate()
        vkService.getMyFriends(vkUserID : vkUserId!)
    }
    
    func tableAndRealmUpdate(){
        guard let realm = try? Realm() else { return }
        friendVK = realm.objects(Friend.self)
        notifToken = friendVK?.observe { [weak self] (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, let delete, let insert, let update):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .none)
                self?.tableView.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .none)
                self?.tableView.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .none)
                self?.tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendVK?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTVCCell
        let friend = friendVK?[indexPath.row]
        
        let getCachedImage = GetCachedImages(url: (friend?.friendPhoto)!)
        let setImageToCell = FetchImages(indexPath: indexPath, tableView: tableView)
        setImageToCell.addDependency(getCachedImage)
        queueForImage.addOperation(getCachedImage)
        OperationQueue.main.addOperation(setImageToCell)
        
        cell.cellNameLabel.text = friend?.friendFullName
        //cell.cellImage.sd_setImage(with: URL(string:(friend?.friendPhoto)!))
        cell.cellImage.layer.cornerRadius = cell.cellImage.frame.height / 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsAllPhotos", let friendPhotoVCV = segue.destination as? FriendPhotosCVC,
            let indexPath = tableView.indexPathForSelectedRow{
            let friendIdentity = friendVK![indexPath.row].id
            friendPhotoVCV.friendId = friendIdentity
        }
        
    }
    
    
    
    func navigationBarSetUp(){
        let myColour = UIColor(red: 76, green: 117, blue: 163, alpha: 1.0)
        
        self.navigationItem.title = "Мои друзья"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.backgroundColor : myColour]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
}



