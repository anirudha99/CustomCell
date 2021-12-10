//
//  ImageMessageViewCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 03/12/21.
//

import UIKit

class ImageMessageViewCell: UICollectionViewCell {
    
    var messageItem: Message? {
        didSet {
            var isSender : Bool
            guard let uid = NetworkManager.shared.getUID() else { return }
            if uid != messageItem?.sender {
                isSender = false
            } else {
                isSender = true
            }
            configureImageCell(isSender: isSender)
        }
    }
    
    var usersArray: [ChatAppUser]? {
        didSet{
            setSenderName()
        }
    }
    
    var messageView : UIView = {
        let mesView = UIView()
        mesView.backgroundColor = .systemGray
        mesView.layer.masksToBounds = true
        mesView.layer.cornerRadius = 10
        mesView.translatesAutoresizingMaskIntoConstraints = false
        return mesView
    }()
    
    let senderLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FontConstants.textfontName
        label.textColor = ColorConstants.lightGreen
        return label
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var userConstraint: NSLayoutConstraint!
    var recieverMessageConstraint: NSLayoutConstraint!
    var senderNameTopConstraint: NSLayoutConstraint!
    var imageUserConstraint: NSLayoutConstraint!
    var imageSenderConstraint: NSLayoutConstraint!
    
    var imageChat: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = ColorConstants.tealGreen
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = ImageConstants.picture
        return image
    }()
    
    var time = CustomLabel(text: "", color: ColorConstants.lightGrayTime, font: UIFont.systemFont(ofSize: 14))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageView)
        messageView.addSubview(time)
        messageView.addSubview(senderLabel)
        messageView.addSubview(imageChat)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint?.isActive = true
        
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
            senderLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            senderLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor,constant: 8),
            senderLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -8),
            
            imageChat.leftAnchor.constraint(equalTo: messageView.leftAnchor),
            imageChat.rightAnchor.constraint(equalTo: messageView.rightAnchor),
            
            time.topAnchor.constraint(equalTo: imageChat.bottomAnchor, constant: -15),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -5)
        ])
        recieverMessageConstraint = imageChat.topAnchor.constraint(equalTo: senderLabel.bottomAnchor,constant: 5)
        senderNameTopConstraint = senderLabel.topAnchor.constraint(equalTo: messageView.topAnchor,constant: 5)
        userConstraint = imageChat.topAnchor.constraint(equalTo: messageView.topAnchor,constant: 10)


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageCell(isSender: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        time.text = dateFormatter.string(from: messageItem!.time)
        time.font = UIFont.systemFont(ofSize: 12)
        messageView.layer.cornerRadius = 10
        
        if isSender {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            senderLabel.isHidden = true
            recieverMessageConstraint.isActive = false
            senderNameTopConstraint.isActive = false
            userConstraint.isActive = true
            
        }
        else {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            messageView.backgroundColor = .systemGray
            senderLabel.isHidden = false
            userConstraint.isActive = false
            recieverMessageConstraint.isActive = true
            senderNameTopConstraint.isActive = true
            
        }
    }
    
    func setSenderName(){
        for user in usersArray! {
            if user.userId == messageItem?.sender {
                senderLabel.text = "\(user.firstName) \(user.lastName)"
            }
        }
    }
}
