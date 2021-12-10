//
//  MessageViewCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 02/12/21.
//

import UIKit

class MessageViewCell: UICollectionViewCell {
    var messageVc: MessageViewController!
    
    var messageItem: Message? {
        didSet {
            var isSender : Bool
            guard let uid = NetworkManager.shared.getUID() else { return }
            if uid != messageItem?.sender {
                isSender = false
            } else {
                isSender = true
            }
            configureCell(isSender: isSender)
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
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var userConstraint: NSLayoutConstraint!
    var recieverMessageConstraint: NSLayoutConstraint!
    var senderNameTopConstraint: NSLayoutConstraint!
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FontConstants.textFont
        return label
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
    
    var time = CustomLabel(text: "", color: ColorConstants.lightGrayTime, font: UIFont.systemFont(ofSize: 12))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageView)
        messageView.addSubview(senderLabel)
        messageView.addSubview(messageLabel)
        messageView.addSubview(time)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        leadingConstraint?.isActive = true
        trailingConstraint = messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        trailingConstraint?.isActive = true
        
        senderNameTopConstraint = senderLabel.topAnchor.constraint(equalTo: messageView.topAnchor,constant: 5)
        recieverMessageConstraint = messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor,constant: 5)
        userConstraint = messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            
            messageView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            senderLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor,constant: 8),
            senderLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -8),
            
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor,constant: 8),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -8),
            
            time.topAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: -10),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor,constant: -5),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(isSender: Bool){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        messageLabel.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        messageView.layer.cornerRadius = 10
        
        if isSender {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.tealGreen
            messageLabel.textColor = .white
            senderLabel.isHidden = true
            userConstraint.isActive = true
            recieverMessageConstraint.isActive = false
            senderNameTopConstraint.isActive = false
            
        }
        else {
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            messageView.backgroundColor = ColorConstants.grayLight
            messageLabel.textColor = ColorConstants.white
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
