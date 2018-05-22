//
//  ConverstationsCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 3/26/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit

class ConverstationsCell: UITableViewCell {

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personPhoto: UIImageView!
    @IBOutlet weak var messageIconLast: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageDate: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
