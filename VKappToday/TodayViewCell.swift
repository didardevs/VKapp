//
//  TodayViewCell.swift
//  VKappToday
//
//  Created by Didar Naurzbayev on 5/28/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit

class TodayViewCell: UITableViewCell {
    
    @IBOutlet weak var cellText: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
