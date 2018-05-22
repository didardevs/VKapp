//
//  FriendsTVCCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 27/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit

class FriendsTVCCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    let makeLabelFrame = LabelFrame()
    let insets: CGFloat = 15.0
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageFrame()
        cellNameLabelFrame()
        
    }

    func cellImageFrame(){
        
        let iconSizeLength: CGFloat = 60
        
        let iconSize = CGSize(width: iconSizeLength, height: iconSizeLength)
        let iconOrigin = CGPoint(x: insets, y: bounds.midY - iconSizeLength/2)
        cellImage.frame = CGRect(origin: iconOrigin, size: iconSize)
        cellImage.layer.cornerRadius = cellImage.frame.height / 2
    }
    
    func cellNameLabelFrame() {
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: cellNameLabel.text!, font: cellNameLabel.font), label: cellNameLabel, labelOriginX: insets + 65, labelOriginY: insets)
    }
}
