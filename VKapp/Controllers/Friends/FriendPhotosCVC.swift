//
//  CollectionsVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 20/02/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "CollectionCell"
private let headerIdentifier = "UserProfileHeader"

class FriendPhotosCVC: UICollectionViewController {

    
    var vkService = VKServices()

    let vkuseid = userDefaults.string(forKey: "userID")
    var friendId = Int()
    var friendPhotos = [Photo]()
    var userName = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register cell classes
        self.collectionView!.register(FriendPhotosCVCCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // background color
        self.collectionView?.backgroundColor = .white
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        collectionView?.collectionViewLayout = layout
        
        configureNavigationBar()
        
        vkService.getAllPhotos(vkUserID : friendId) { [weak self] friendPhotos in
            self?.friendPhotos = friendPhotos
            self?.collectionView?.reloadData()
        }
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendPhotosCVCCell
        let friendPhoto = friendPhotos[indexPath.row]
        cell.post = friendPhoto
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
extension FriendPhotosCVC : UICollectionViewDelegateFlowLayout{
    //MARK: - UICollectionViewDelegateFlowLayout
    
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
    
    
}
