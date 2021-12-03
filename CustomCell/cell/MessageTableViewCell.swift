//
//  MessageTableViewCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var messageItem: Message? {
        didSet {
            var isSender : Bool
            guard let uid = NetworkManager.shared.getUID() else { return }
            if uid != messageItem?.sender {
                isSender = false
            } else {
                isSender = true
            }
            if messageItem!.imagePath! == "" {
                configureCell(isSender: isSender)
            } else {
                configureImageCell(isSender: isSender)
            }
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
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "San Francisco Pro Display", size: 20)
        return label
    }()
    
    var imageChat: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = ImageConstants.picture
        return image
    }()
    
    var time = CustomLabel(text: "")
    
    func configureCell(isSender: Bool){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        addSubview(messageView)
        messageView.addSubview(messageLabel)
//        addSubview(messageLabel)
        addSubview(time)
        messageLabel.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        time.font = UIFont.systemFont(ofSize: 12)
        messageView.layer.cornerRadius = 10
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint?.isActive = true
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint?.isActive = true

        if isSender {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            messageView.backgroundColor = .systemRed
            messageLabel.textColor = .white
        }
        else {
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            messageView.backgroundColor = .systemGray
            messageLabel.textColor = .black
        }
        
        NSLayoutConstraint.activate([
            
            messageView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
//            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
//            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
//            messageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
//            messageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
//            messageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor,constant: -16),
//            messageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor,constant: 16),
            
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor,constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor,constant: -5),
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor,constant: 8),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -8),
            
            time.topAnchor.constraint(equalTo: messageView.bottomAnchor,constant: -16),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor)
        ])
    }
    
    func configureImageCell(isSender: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        NetworkManager.shared.downloadImageWithPath(path: messageItem!.imagePath!, completion: { image in
            DispatchQueue.main.async {
                self.imageChat.image = image
            }
        })
        addSubview(messageView)
        addSubview(time)
        messageView.addSubview(imageChat)
        time.text = dateFormatter.string(from: messageItem!.time)
        time.font = UIFont.systemFont(ofSize: 12)
        messageView.layer.cornerRadius = 10
        messageView.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint.isActive = true
        
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint.isActive = true
        
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
            messageView.heightAnchor.constraint(equalToConstant: 200),
            messageView.widthAnchor.constraint(equalToConstant: 200),
            
            imageChat.topAnchor.constraint(equalTo: messageView.topAnchor),
            imageChat.leftAnchor.constraint(equalTo: messageView.leftAnchor),
            imageChat.widthAnchor.constraint(equalTo: messageView.widthAnchor),
            imageChat.heightAnchor.constraint(equalTo: messageView.heightAnchor),
            
            time.topAnchor.constraint(equalTo: imageChat.bottomAnchor, constant: -16),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor)
        ])
    }
}
