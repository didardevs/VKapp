//
//  SearchTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 21/02/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class GroupsTableView: UITableViewController {
    var vkService = GroupRequests()
    let vkuseid = userDefaults.string(forKey: "userID")
    var groupsVK: Results<Group>?
    
    var notifToken: NotificationToken?
    var counter = 0
    
    let queueForImage: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        tableAndRealmUpdate()
        vkService.getMyGroups(vkUserID: vkuseid!)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsVK?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! GroupsTVCell
        
        let group = groupsVK?[indexPath.row]
        
        let getCachedImage = GetCachedImages(url: (group?.groupPhoto)!)
        let setImageToCell = FetchImages(indexPath: indexPath, tableView: tableView)
        setImageToCell.addDependency(getCachedImage)
        queueForImage.addOperation(getCachedImage)
        OperationQueue.main.addOperation(setImageToCell)
        
        
        cell.cellLabel.text = group?.groupName
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    func tableAndRealmUpdate(){
        guard let realm = try? Realm() else { return }
        groupsVK = realm.objects(Group.self)
        notifToken = groupsVK?.observe { [weak self] (changes: RealmCollectionChange) in
            
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let groupToDelete = groupsVK?[indexPath.row] else { return }
            vkService.leaveGroup(groupID: groupToDelete.id)
            Realm.deleteDataFromRealm(objects: [groupsVK![indexPath.row]])
        }
    }
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if segue.identifier == "addGroup"{
            let moreGroupsVC = segue.source as! MoreGroupsTVC
            if let indexPath = moreGroupsVC.tableView.indexPathForSelectedRow {
                let newGroup = moreGroupsVC.searchedGroup[indexPath.row]
                if !(groupsVK?.contains(where: { $0.id == newGroup.id } ))! {
                    vkService.joinGroup(groupID: newGroup.id)
                    Realm.newDataToRealm(objects: [newGroup])
                    
                    //                    let application = UIApplication.shared
                    //
                    //                    DispatchQueue.main.async {
                    //                        application.applicationIconBadgeNumber =
                    //                            userDefaults.integer(forKey: "newgroupCount")
                    //                    }
                    //                    
                    let firebase = FirebaseService()
                    firebase.saveUsersGroups(group: newGroup)
                }
            }
        }
    }
    func navigationBarSetUp(){
        self.navigationItem.title = "Мои группы"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
    
    
}

