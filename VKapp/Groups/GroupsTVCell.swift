//
//  SearchTVCCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 20/02/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit

class GroupsTVCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    let makeLabelFrame = LabelFrame()
    let insets : CGFloat = 15.0
    override func awakeFromNib() {
        
        super.awakeFromNib()
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageFrame()
        groupLabelFrame()
        
    }
    
    func cellImageFrame(){
        
        let iconSizeLength: CGFloat = 60
        
        let iconSize = CGSize(width: iconSizeLength, height: iconSizeLength)
        let iconOrigin = CGPoint(x: insets, y: bounds.midY - iconSizeLength/2)
        cellImage.frame = CGRect(origin: iconOrigin, size: iconSize)
        cellImage.layer.cornerRadius = cellImage.frame.height / 2
    }
    
    func groupLabelFrame() {
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: cellLabel.text!, font: cellLabel.font), label: cellLabel, labelOriginX: insets + 65, labelOriginY: insets)
    }
    
    
}
