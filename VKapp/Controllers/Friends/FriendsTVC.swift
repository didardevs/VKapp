//
//  FriendsTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 26/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifer = "FriendsCell"

class FriendsTVC: UITableViewController {
    
    var vkService = VKServices()
    let userID = userDefaults.string(forKey: "userID")
    var friendVK: Results<Friend>?
    var notifToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FriendsTVCCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.separatorColor = .clear
        
        configureNavigationBar()
        tableAndRealmUpdate()
        vkService.getMyFriends()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! FriendsTVCCell
        let friendCell = friendVK?[indexPath.row]
       
        cell.friend = friendCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = friendVK?[indexPath.row]
        
        let userProfileVC = FriendPhotosCVC(collectionViewLayout: UICollectionViewFlowLayout())
        guard let id = user?.id else { return }
        userProfileVC.friendId = id
        userProfileVC.navigationItem.title = userProfileVC.userName
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    

    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 35, green: 40, blue: 58)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationItem.title = "Мои друзья"
        
    }
}



