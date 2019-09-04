//
//  FriendPhotosCVCCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 27/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit

class FriendPhotosCVCCell: UICollectionViewCell {
    
    var post: Photo? {
        
        didSet {
            guard let imageUrl = post?.smallPhotoURL else { return }
            postImageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
    
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

