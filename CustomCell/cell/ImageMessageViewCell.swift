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
    
    var messageView : UIView = {
        let mesView = UIView()
        mesView.backgroundColor = .systemGray
        mesView.layer.masksToBounds = true
        mesView.layer.cornerRadius = 10
        mesView.translatesAutoresizingMaskIntoConstraints = false
        return mesView
    }()
    
    var widthConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var imageChat: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = ImageConstants.picture
        return image
    }()
    
    var time = CustomLabel(text: "")
    
    func configureImageCell(isSender: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        addSubview(messageView)
        addSubview(time)
        messageView.addSubview(imageChat)
        time.text = dateFormatter.string(from: messageItem!.time)
        time.font = UIFont.systemFont(ofSize: 12)
        messageView.layer.cornerRadius = 10
        messageView.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint?.isActive = true
        
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint?.isActive = true
        //        widthConstraint = messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        //        widthConstraint?.isActive = true
        
        if isSender {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            messageView.backgroundColor = .systemRed
        }
        else {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            messageView.backgroundColor = .systemGray
        }
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            //            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            imageChat.topAnchor.constraint(equalTo: messageView.topAnchor),
            imageChat.leftAnchor.constraint(equalTo: messageView.leftAnchor),
            imageChat.widthAnchor.constraint(equalTo: messageView.widthAnchor),
            imageChat.heightAnchor.constraint(equalTo: messageView.heightAnchor),
            
            time.topAnchor.constraint(equalTo: imageChat.bottomAnchor, constant: -16),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor)
        ])
    }
    
}
