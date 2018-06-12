//
//  AllGroupsTVCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 26/02/2018.
//  Copyright © 2018 NoName. All rights reserved.
//

import UIKit

class MoreGroupsTVCCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupParticipants: UILabel!
    
    let makeLabelFrame = LabelFrame()
    let insets : CGFloat = 15.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        groupName.translatesAutoresizingMaskIntoConstraints = false
        groupParticipants.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageFrame()
        groupLabelFrame()
        participantLabelFrame()
        
    }
    
    func cellImageFrame(){
        
        let iconSizeLength: CGFloat = 60
        
        let iconSize = CGSize(width: iconSizeLength, height: iconSizeLength)
        let iconOrigin = CGPoint(x: insets, y: bounds.midY - iconSizeLength/2)
        cellImage.frame = CGRect(origin: iconOrigin, size: iconSize)
        cellImage.layer.cornerRadius = cellImage.frame.height / 2
    }
    
    
    func groupLabelFrame() {
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: groupName.text!, font: groupName.font), label: groupName, labelOriginX: insets + 65, labelOriginY: insets)
    }
    
    func participantLabelFrame(){
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: groupParticipants.text!, font: groupParticipants.font), label: groupParticipants, labelOriginX: insets + 65, labelOriginY: insets * 3)
    }
    
    
}
