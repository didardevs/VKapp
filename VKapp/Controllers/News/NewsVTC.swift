//
//  NewsVTC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 6/7/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifer = "newsID"

class NewsVTC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var vkService = GetNews()
    var vkNewsfeeds: Results<VKNewsFeed2>?
    var notifToken: NotificationToken?

    let accessToken = UserDefaults.standard.string(forKey: "token")
    


    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor? = UIColor.white
        tableView.frame = view.bounds
        tableView.register(NewsTVCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 223
        tableView.rowHeight = UITableView.automaticDimension
        tableView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        configureNavigationBar()
        tableAndRealmUpdate()
        vkService.getAllPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vkNewsfeeds?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsID", for: indexPath) as! NewsTVCell
        
        let newsfeed = vkNewsfeeds![indexPath.row]
        cell.news = newsfeed
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
        navigationItem.title = "Новости"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(createPost))
        
    }
    
    @objc func createPost(){
        let followVC = AddMyPost()
        navigationController?.pushViewController(followVC, animated: true)
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
