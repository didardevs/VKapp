//
//  FriendPhotosCVCCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 27/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit

class FriendPhotosCVCCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    let insets: CGFloat = 10
    override func awakeFromNib() {
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        super.awakeFromNib()
       
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       cellImageFrame()
        }
    
    func cellImageFrame(){
        let iconSizeLength: CGFloat = 100
        let iconSize = CGSize(width: iconSizeLength, height: iconSizeLength)
        let iconOrigin = CGPoint(x: bounds.midX - iconSizeLength / 2, y: bounds.midY - iconSizeLength/2)
        cellImage.frame = CGRect(origin: iconOrigin, size: iconSize)
    }

}

