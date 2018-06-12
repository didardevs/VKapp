//
//  LabelFrame.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/9/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
class LabelFrame{
    let insets : CGFloat = 15.0
    func getLabelSize(bounds: CGRect, text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - insets
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func labelFrame (labelSize: CGSize, label: UILabel, labelOriginX: CGFloat, labelOriginY: CGFloat) {
        let labelOrigin = CGPoint(x: labelOriginX, y: labelOriginY)
        label.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    
    
}
