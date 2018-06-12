//
//  AllGroupsTVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 26/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit

class MoreGroupsTVC: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var vkService = GroupRequests()
    var searchedGroup = [Group]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetup()
        searchBarSetup()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedGroup.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! MoreGroupsTVCCell
        
        let searchGroup = searchedGroup[indexPath.row]
        cell.groupName.text = searchGroup.groupName
        cell.groupParticipants.text = "members: " + searchGroup.memberCount
        cell.cellImage.sd_setImage(with: URL(string:searchGroup.groupPhoto))
        //cell.cellImage.layer.cornerRadius = cell.cellImage.frame.height / 2
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    
    func navigationBarSetup(){
        self.navigationItem.title = "Groups"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
    func searchBarSetup(){
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
            
            definesPresentationContext = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.searchBar.sizeToFit()
            searchController.loadViewIfNeeded()
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        vkService.searchGroups(q: searchController.searchBar.text!.lowercased()) { [weak self] searchedGroup in
            self?.searchedGroup = searchedGroup
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}

