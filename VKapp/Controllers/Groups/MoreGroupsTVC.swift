//
//  AllGroupsTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 26/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifer = "GroupCell"

class MoreGroupsTVC: UITableViewController, UISearchBarDelegate {
    
    var vkService = GroupRequests()
    var searchedGroup = [Group]()
    var searchBar = UISearchBar()
    var inSearchMode = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MoreGroupsTVCCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.separatorColor = .clear
        navigationBarSetup()
        // configure search bar
        configureSearchBar()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedGroup.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MoreGroupsTVCCell
        
        let groupCell = searchedGroup[indexPath.row]
        
        cell.group = groupCell
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup = searchedGroup[indexPath.row]
        vkService.joinGroup(groupID: selectedGroup.id)
        Realm.newDataToRealm(objects: [selectedGroup])
        _ = navigationController?.popViewController(animated: true)
        
    }
    func navigationBarSetup(){
        self.navigationItem.title = "Groups"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    // MARK: - UISearchBar
    
    func configureSearchBar() {
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        searchBar.tintColor = .white
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        tableView.separatorColor = .lightGray
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased()
        
        if searchText.isEmpty || searchText == " " {
            inSearchMode = false
            tableView.reloadData()
        } else {
            inSearchMode = true
            
            vkService.searchGroups(q: searchText) { [weak self] searchedGroup in
                self?.searchedGroup = searchedGroup
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    
        searchBar.text = nil
        inSearchMode = false
        tableView.separatorColor = .clear
        tableView.reloadData()
    }
    
}
