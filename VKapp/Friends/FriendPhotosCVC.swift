//
//  CollectionsVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 20/02/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import RealmSwift

class FriendPhotosCVC: UICollectionViewController {
    var vkService = VKServices()
    var friendPhotos = [VKFriendsPhoto]()
    let vkuseid = userDefaults.string(forKey: "userID")
    var friendId = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        collectionView?.collectionViewLayout = layout
        
        navigationBarSetUp()
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotos", for: indexPath) as! FriendPhotosCVCCell
        let friendPhoto = friendPhotos[indexPath.row]
        cell.cellImage.sd_setImage(with: URL(string:friendPhoto.smallPhotoURL))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    
    func navigationBarSetUp(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
}
extension FriendPhotosCVC : UICollectionViewDelegateFlowLayout{
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    
}
