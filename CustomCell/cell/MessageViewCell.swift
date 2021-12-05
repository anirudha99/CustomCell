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
            //            var height = messageVc.estimateTextFrame(text: messageItem!.content).width + 32
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
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "San Francisco Pro Display", size: 20)
        return label
    }()
    
    var time = CustomLabel(text: "")
    
    func configureCell(isSender: Bool){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        addSubview(messageView)
        messageView.addSubview(messageLabel)
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
        //        widthConstraint = messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        //        widthConstraint?.isActive = true
        
        if isSender {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            messageView.backgroundColor = .systemRed
            messageLabel.textColor = .white
        }
        else {
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            messageView.backgroundColor = UIColor(white: 0.75, alpha: 1)
            messageLabel.textColor = .black
        }
        
        NSLayoutConstraint.activate([
            
            messageView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor,constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor,constant: -5),
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor,constant: 8),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor,constant: -8),
            
            time.topAnchor.constraint(equalTo: messageView.bottomAnchor,constant: -16),
            time.rightAnchor.constraint(equalTo: messageView.rightAnchor)
        ])
    }
}
