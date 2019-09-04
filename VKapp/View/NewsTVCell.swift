//
//  NewsTVCell.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 3/26/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit

class NewsTVCell: UITableViewCell {
    var news: VKNewsFeed2? {
        didSet {
            usernameLabel.text = news?.postOwner
            timeStampLabel.text = timeStringFromUnixTime(unixTime: news!.postTimeStamp)
            postTextLabel.text = news?.postText
            iconImage.sd_setImage(with: URL(string: news!.ownerIcon))
            postImageView.sd_setImage(with: URL(string: news!.postImage))
            likesLabel.text = divideByK(number: news!.likesCount)
            commentLabel.text = divideByK(number: news!.commentsCount)
            sharesLabel.text = divideByK(number: news!.repostCount)
            viewersLabel.text = divideByK(number: news!.repostCount)
        }
    }
    
    var stackView: UIStackView!
    
    let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Bold", size: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    let postTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Medium", size: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"likes"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"comments"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var sharesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"shared"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    lazy var viewersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"viewers"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let sharesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    let viewersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Light", size: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    func timeStringFromUnixTime(unixTime: Double) -> String{
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "ru_RU_POSIX")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    func divideByK(number: Double) -> String {
        switch number{
        case _ where number < 1000: return String(format: "%.0f", number)
        case _ where number >= 1000 && number <= 1099: return "1K"
        case _ where number > 1100 && number < 9999: return String(format: "%.1f",(number/1000)) + "K"
        case _ where number > 10000 && number < 99999: return String(format: "%.1f",(number/10000)) + "K"
        default:
            return String(format: "%.1f", number)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImage)
        iconImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        iconImage.layer.cornerRadius = 40 / 2
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: iconImage.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: usernameLabel.bottomAnchor, left: iconImage.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(middleView)
        middleView.anchor(top: iconImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        middleView.addSubview(postTextLabel)
        postTextLabel.anchor(top: middleView.topAnchor, left: middleView.leftAnchor, bottom: middleView.bottomAnchor, right: middleView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(postImageView)
        postImageView.anchor(top: middleView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        configureActionButtons()
    }
    
    func configureActionButtons() {
        
        let likeView = UIView()
        likeView.addSubview(likeButton)
        likeButton.anchor(top: likeView.topAnchor, left: likeView.leftAnchor, bottom: likeView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 20)
        likeView.addSubview(likesLabel)
        likesLabel.anchor(top: likeView.topAnchor, left: likeButton.rightAnchor, bottom: likeView.bottomAnchor, right: likeView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 20)
        let commentView = UIView()
        commentView.addSubview(commentButton)
        commentButton.anchor(top: commentView.topAnchor, left: commentView.leftAnchor, bottom: commentView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 20)
        commentView.addSubview(commentLabel)
        commentLabel.anchor(top: commentView.topAnchor, left: commentButton.rightAnchor, bottom: commentView.bottomAnchor, right: commentView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 20)
        
        let shareView = UIView()
        shareView.addSubview(sharesButton)
        sharesButton.anchor(top: shareView.topAnchor, left: shareView.leftAnchor, bottom: shareView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 20)
        shareView.addSubview(sharesLabel)
        sharesLabel.anchor(top: shareView.topAnchor, left: sharesButton.rightAnchor, bottom: shareView.bottomAnchor, right: shareView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 60, height: 20)
        stackView = UIStackView(arrangedSubviews: [likeView, commentView, shareView])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 200, height: 30)
        let viewersView = UIView()
        viewersView.addSubview(viewersButton)
        viewersButton.anchor(top: viewersView.topAnchor, left: viewersView.leftAnchor, bottom: viewersView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 20)
        viewersView.addSubview(viewersLabel)
        viewersLabel.anchor(top: viewersView.topAnchor, left: viewersButton.rightAnchor, bottom: viewersView.bottomAnchor, right: viewersView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 20)
        addSubview(viewersView)
        viewersView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
