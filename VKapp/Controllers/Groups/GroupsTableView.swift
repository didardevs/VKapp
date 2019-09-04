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

private let reuseIdentifer = "GroupCell"

class GroupsTableView: UITableViewController {
    var vkService = GroupRequests()
    let vkuseid = userDefaults.string(forKey: "userID")
    var groups: Results<Group>?
    
    var notifToken: NotificationToken?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GroupsTVCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.separatorColor = .clear
        configureNavigationBar()
        tableAndRealmUpdate()
        vkService.getMyGroups(vkUserID: vkuseid!)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! GroupsTVCell
        
        let groupCell = groups?[indexPath.row]

        cell.group = groupCell
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableAndRealmUpdate(){
        guard let realm = try? Realm() else { return }
        groups = realm.objects(Group.self)
        notifToken = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let groupToDelete = groups?[indexPath.row] else { return }
            vkService.leaveGroup(groupID: groupToDelete.id)
            Realm.deleteDataFromRealm(objects: [groups![indexPath.row]])
        }
    }
    
//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//
//        if segue.identifier == "addGroup"{
//            let moreGroupsVC = segue.source as! MoreGroupsTVC
//            if let indexPath = moreGroupsVC.tableView.indexPathForSelectedRow {
//                let newGroup = moreGroupsVC.searchedGroup[indexPath.row]
//                if !(groups?.contains(where: { $0.id == newGroup.id } ))! {
//                    vkService.joinGroup(groupID: newGroup.id)
//                    Realm.newDataToRealm(objects: [newGroup])
//
//                    //                    let application = UIApplication.shared
//                    //
//                    //                    DispatchQueue.main.async {
//                    //                        application.applicationIconBadgeNumber =
//                    //                            userDefaults.integer(forKey: "newgroupCount")
//                    //                    }
//                    //
//
//                }
//            }
//        }
//    }
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
        navigationItem.title = "Мои группы"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(openSearch))
        
    }
    
    @objc func openSearch(){
        let followVC = MoreGroupsTVC()        
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    
    
}

