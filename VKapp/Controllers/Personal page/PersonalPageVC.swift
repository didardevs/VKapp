//
//  PersonalPageVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 6/9/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

private let reuseIdentifier = "Cell"
private let headerIdentifier = "UserProfileHeader"

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    // MARK: - Properties
    var vkService = VKServices()
    var user = User()
    let vkuseid = userDefaults.string(forKey: "userID")

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell classes
        self.collectionView!.register(FriendPhotosCVCCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // background color
        self.collectionView?.backgroundColor = .white
        vkService.userInfo(userID: vkuseid!) { [weak self] userArray in
            self!.user = userArray[0]
            print(userArray[0].fullName)
            print(self!.user.fullName)
        }
        configureNavigationBar()

    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    // MARK: - UICollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // declare header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! UserProfileHeader

        header.nameLabel.text = user.fullName
        navigationItem.title = user.fullName
        
 

        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendPhotosCVCCell
        

        
        return cell
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

        
    }

   
}

class PersonalPageVC: UIViewController {
    
//    @IBOutlet weak var fullname: UILabel!
//
//    @IBOutlet weak var yearPlace: UILabel!
//    @IBOutlet weak var image: UIImageView!
//    @IBOutlet weak var groupCount: UILabel!
//
//    @IBOutlet weak var friendCount: UILabel!
//
//    var vkService = VKServices()
//
//    let vkuseid = userDefaults.string(forKey: "userID")
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        vkService.userInfo(userID: vkuseid!) { [weak self] userArray in
//            if userArray.count > 0 {
//                let user = userArray[0]
//                self?.fullname.text = user.fullName
//                self?.yearPlace.text = user.status
//                if user.userImage != ""{
//                    self?.image.sd_setImage(with: URL(string:user.userImage))
//                }
//                let friendNum = self?.getStringProperty(property: user.counters["friends"])
//                let groupNum = self?.getStringProperty(property: user.counters["groups"])
//
//                self?.groupCount.text = groupNum
//                self?.friendCount.text = friendNum
//            }
//        }
//
//
//    }
//
//
//
//    func getStringProperty(property: Int?) -> String {
//        if let intProperty = property {
//            return String(intProperty)
//        } else {
//            return ""
//        }
//    }
//
}


