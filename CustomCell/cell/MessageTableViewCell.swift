//
//  MessageTableViewCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 17/11/21.
//

import UIKit
import SwiftUI

class MessageTableViewCell: UITableViewCell {
    
    var profilePic: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
        image.backgroundColor = .white
        image.layer.borderColor = UIColor.systemRed.cgColor
        image.layer.borderWidth = 3
        image.layer.cornerRadius = 35
        return image
    }()
    
    var messageTextView: UITextView = {
        let tview = UITextView()
        tview.translatesAutoresizingMaskIntoConstraints  = false
        tview.isEditable = false
        tview.isUserInteractionEnabled = false
        tview.contentInsetAdjustmentBehavior = .automatic
        tview.textAlignment = .justified
        tview.backgroundColor = UIColor.lightGray
        return tview
    }()
    
    //MARK: - Init
    
    func configure(){
        addSubview(profilePic)
        addSubview(messageTextView)
        
        let stack = UIStackView(arrangedSubviews: [profilePic, messageTextView])
        stack.axis = .horizontal
        stack.spacing = 5
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
    }
}
