//
//  MessageTableViewCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit
import SwiftUI

class MessageTableViewCell: UITableViewCell {
    
//    var profilePic: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.masksToBounds = true
//        image.contentMode = .scaleToFill
//        image.backgroundColor = .white
//        image.layer.borderColor = UIColor.systemRed.cgColor
//        image.layer.borderWidth = 3
//        image.layer.cornerRadius = 35
//        return image
//    }()
    
//    var messageTextView: UITextView = {
//        let tview = UITextView()
//        tview.translatesAutoresizingMaskIntoConstraints  = false
//        tview.isEditable = false
//        tview.isUserInteractionEnabled = false
//        tview.contentInsetAdjustmentBehavior = .automatic
//        tview.textAlignment = .justified
//        tview.backgroundColor = UIColor.lightGray
//        return tview
//    }()
    
    var messageItem: Message? {
           didSet {
               var isSender = true
               guard let uid = NetworkManager.shared.getUID() else { return }
               if uid != messageItem?.sender {
                   isSender = false
               }
               configureCell(isSender: isSender)
           }
       }
    let messagebackgroundView = UIView()
    
    var messageView = UIView()
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var time = CustomLabel(text: "")
    
    func configureCell(isSender: Bool){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        messageLabel.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        messageView.layer.cornerRadius = 10
        addSubview(messageView)
        messageView.addSubview(time)
        messageView.addSubview(messageLabel)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = messageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        if isSender {
            print("Sender 1\(messageItem?.content)")
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            messageView.backgroundColor = .systemGray
        }
        else {
            print("Sender 2\(messageItem?.content)")
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            messageView.backgroundColor = .systemRed
        }
        
        NSLayoutConstraint.activate([
            
            messageLabel.widthAnchor.constraint(equalToConstant: 200),
            messageView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 60),
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -10),
        ])
    }
}
    
    //MARK: - old
    
//    var leadingConstraint: NSLayoutConstraint!
//    var trailingConstraint: NSLayoutConstraint!
//    
//    var chatMessage : ChatMessage! {
//        didSet{
//            messagebackgroundView.backgroundColor = chatMessage.isIncoming ? .systemGray : .systemRed
//            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
//            messageLabel.text = chatMessage.text
//
//            if chatMessage.isIncoming {
//                leadingConstraint.isActive = true
//                trailingConstraint.isActive = false
//            } else{
//                leadingConstraint.isActive = false
//                trailingConstraint.isActive = true
//            }
//        }
//    }
    
//    var isIncoming: Bool! {
//        didSet{
//            messagebackgroundView.backgroundColor = isIncoming ? .systemGray : .systemRed
//            messageLabel.textColor = isIncoming ? .black : .white
//        }
//    }
    
    //MARK: - Init
    
//    func configure(){
//        addSubview(profilePic)
//        addSubview(messageTextView)
        
//        let stack = UIStackView(arrangedSubviews: [profilePic, messageTextView])
//        stack.axis = .horizontal
//        stack.spacing = 5
//        addSubview(stack)
        
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
//    }
    
    //MARK: - old

//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        backgroundColor = .clear
//        messagebackgroundView.backgroundColor = .yellow
//        messagebackgroundView.layer.cornerRadius = 12
//
//        addSubview(messagebackgroundView)
//        addSubview(messageLabel)
//
//        //        messageLabel.text = "Some text Some text Some text Some text Some text Some text Some text Some text"
//        messageLabel.numberOfLines = 0
//
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        messagebackgroundView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
//            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
//            //            messageLabel.widthAnchor.constraint(equalToConstant: 250),
//            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//
//            messagebackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
//            messagebackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
//            messagebackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
//            messagebackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16)
//
//        ])
//
//        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//        leadingConstraint.isActive = true
//
//        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//        trailingConstraint.isActive = true
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
