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
            var isSender = true
            guard let uid = NetworkManager.shared.getUID() else { return }
            if uid != messageItem?.sender {
                isSender = false
            }
            configureCell(isSender: isSender)
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
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var time = CustomLabel(text: "")
    
    func configureCell(isSender: Bool){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        addSubview(messageView)
//        messageView.addSubview(messageLabel)
//        messageView.addSubview(time)
        addSubview(messageLabel)
        addSubview(time)
        messageLabel.text = messageItem!.content
        time.text = dateFormatter.string(from: messageItem!.time)
        time.font = UIFont.systemFont(ofSize: 12)
        messageView.layer.cornerRadius = 10
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = true

        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    
        
        
        if isSender {
            //            print("Sender 1\(messageItem?.content)")
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            
            messageView.backgroundColor = .systemRed
            messageLabel.textColor = .white
        }
        else {
            //            print("Sender 2\(messageItem?.content)")
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            
            messageView.backgroundColor = .systemGray
            messageLabel.textColor = .black
        }
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
          
            messageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            messageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            messageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor,constant: -16),
            messageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor,constant: 16),
            
            time.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor),

         
            
        ])
    }
}
