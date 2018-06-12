//
//  NewsTVCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 3/26/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit

class NewsTVCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewersLabel: UILabel!
    
    @IBOutlet weak var myView: UIView!
    weak var delegate: NewsTVCellHeightDelegate?
    var index: IndexPath?
    let makeLabelFrame = LabelFrame()
    let insets: CGFloat = 10.0
    let sideInset: CGFloat = 45.0
    var cellHeight: CGFloat?
    
    @IBOutlet weak var likesImage: UIImageView!
    
    @IBOutlet weak var commentsImage: UIImageView!
    
    @IBOutlet weak var sharedImage: UIImageView!
    @IBOutlet weak var viewersImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        [iconImage, nameLabel, timeStamp, postTextLabel, postImage, likesImage, commentsImage, sharedImage, viewersImage, likesLabel, commentsLabel, sharesLabel, viewersLabel, myView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [iconImage, nameLabel, timeStamp, postTextLabel, postImage, likesImage, commentsImage, sharedImage, viewersImage, likesLabel, commentsLabel, sharesLabel, viewersLabel, myView].forEach { $0?.backgroundColor = .white }
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageFrame()
        nameLabelFrame()
        timeStampLabelFrame()
        postLabelFrame()
        postImageFrame()
        viewFrame()
        likesImageFrame()
        likesLabelFrame()
        commentImageFrame()
        commentFrame()
        repostImageFrame()
        repostLabelFrame()
        viewersImageFrame()
        viewersLabelFrame()
        cellCurrentHeight()
    }
    
    func cellCurrentHeight(){
        cellHeight = 2 * insets + 3 * 4 + iconImage.frame.height + postTextLabel.frame.height + postImage.frame.height + myView.frame.height
        delegate?.setCellHeight(cellHeight!, index!)
    }
    
    func cellImageFrame(){
        
        let iconSizeLength: CGFloat = 40
        
        let iconSize = CGSize(width: iconSizeLength, height: iconSizeLength)
        let iconX = 2 * insets
        let iconY = insets
        let iconOrigin = CGPoint(x: iconX, y: iconY)
        iconImage.frame = CGRect(origin: iconOrigin, size: iconSize)
        iconImage.layer.cornerRadius = iconImage.frame.height / 2
    }
    
    func nameLabelFrame() {
        let nameLabelSize = getDateSize(text: nameLabel.text!, font: nameLabel.font)
        let labelX = 4 * insets + sideInset
        let labelY = insets * 0.5 + 25 - nameLabelSize.height
        let labelOrigin = CGPoint(x: labelX, y: labelY)
        nameLabel.frame = CGRect(origin: labelOrigin, size: nameLabelSize)
    }
    
    func timeStampLabelFrame(){
        let timeStampSize = getDateSize(text: timeStamp.text!, font: timeStamp.font)
        let labelX = 4 * insets + sideInset
        let labelY = insets * 1.5 + 25
        let labelOrigin = CGPoint(x: labelX, y: labelY)
        timeStamp.frame = CGRect(origin: labelOrigin, size: timeStampSize)
    }
    
    func postLabelFrame() {
        let postLabelSize = getTextLabelSize(text: postTextLabel.text!, font: postTextLabel.font)
        let labelX = 2 * insets
        let labelY = iconImage.frame.origin.y + iconImage.frame.size.height + insets
        let postLabelOrigin = CGPoint(x: labelX, y: labelY)
        postTextLabel.frame = CGRect(origin: postLabelOrigin, size: postLabelSize)
        
    }
    
    func postImageFrame(){
        
        let iconSizeLength: CGFloat = 208
        let iconSize = CGSize(width: iconSizeLength, height: iconSizeLength)
        let imageX = bounds.midX - iconSizeLength/2
        let imageY = postTextLabel.frame.origin.y + postTextLabel.frame.size.height + insets
        let iconOrigin = CGPoint(x: imageX, y: imageY)
        postImage.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    func viewFrame(){
        let viewWidth: CGFloat = 246
        let viewHeight: CGFloat  = 30
        
        let viewSize = CGSize(width: viewWidth, height: viewHeight)
        let viewY = postImage.frame.origin.y + postImage.frame.size.height + insets
        let viewOrigin = CGPoint(x: insets, y: viewY)
        myView.frame = CGRect(origin: viewOrigin, size: viewSize)
    }
    
    // inside of view
    func likesImageFrame(){
        let imageLength: CGFloat = 20
        let imageSize = CGSize(width: imageLength, height: imageLength)
        let imageOrigin = CGPoint(x: 0, y: 0)
        likesImage.frame = CGRect(origin: imageOrigin, size: imageSize)
    }
    
    func likesLabelFrame(){
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: likesLabel.text!, font: likesLabel.font), label: likesLabel, labelOriginX: 22, labelOriginY: 0 )
    }
    func commentImageFrame(){
        let imageLength: CGFloat = 20
        let imageSize = CGSize(width: imageLength, height: imageLength)
        let imageOrigin = CGPoint(x: 60, y: 0)
        commentsImage.frame = CGRect(origin: imageOrigin, size: imageSize)
    }
    
    func commentFrame(){
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: commentsLabel.text!, font: commentsLabel.font), label: commentsLabel, labelOriginX: 82, labelOriginY: 0 )
    }
    
    func repostImageFrame(){
        let imageLength: CGFloat = 20
        let imageSize = CGSize(width: imageLength, height: imageLength)
        let imageOrigin = CGPoint(x: 110, y: 0)
        sharedImage.frame = CGRect(origin: imageOrigin, size: imageSize)
    }
    
    func repostLabelFrame(){
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: sharesLabel.text!, font: sharesLabel.font), label: sharesLabel, labelOriginX: 132, labelOriginY: 0 )
    }
    
    func viewersImageFrame(){
        let imageLength: CGFloat = 20
        let imageSize = CGSize(width: imageLength, height: imageLength)
        let imageOrigin = CGPoint(x: 250, y: 0)
        viewersImage.frame = CGRect(origin: imageOrigin, size: imageSize)
    }
    
    func viewersLabelFrame(){
        makeLabelFrame.labelFrame(labelSize: makeLabelFrame.getLabelSize(bounds: bounds, text: viewersLabel.text!, font: viewersLabel.font), label: viewersLabel, labelOriginX: 272, labelOriginY: 0 )
    }
    
    //myfunctions
    
    func getTextLabelSize(text: String, font: UIFont) -> CGSize{
        let maxWidth = bounds.width - 4 * insets
        let textBlock = CGSize(width: maxWidth, height: 90.0)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func getDateSize(text: String, font: UIFont) -> CGSize{
        let maxWidth = bounds.width - 5 * insets - 50
        let textBlock = CGSize(width: maxWidth, height: (50 - 3 * insets)/2)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
}
