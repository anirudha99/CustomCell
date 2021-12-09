//
//  ConversationCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 09/11/21.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var delegate: ChatSelectedDelegate?
    var isChecked:Bool = false
    var initialFetch: Bool = false
    
    var lastMessageItem: Message? {
        didSet {
            checkLastMessage()
        }
    }
    
    var chat: Chats? {
        didSet {
            configureChat()
        }
    }
    
    var messageView = UIView()
    
    let checkBox: UIButton = {
        let cbutton = UIButton()
        cbutton.translatesAutoresizingMaskIntoConstraints = false
        cbutton.setImage(ImageConstants.square, for: .normal)
        cbutton.tintColor = .systemRed
        return cbutton
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = ""
        label.lineBreakMode = .byTruncatingTail
        label.textColor = ColorConstants.whiteChocolate
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = ""
        label.textColor = ColorConstants.customWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        label.text = dateFormatter.string(from: Date())
        label.textColor = ColorConstants.whiteChocolate
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .clear
        return label
    }()
    
    let iconImageView : UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        imageV.image = ImageConstants.personFill
        imageV.tintColor = ColorConstants.tealGreen
        imageV.layer.cornerRadius = 20
        imageV.layer.borderColor = ColorConstants.tealGreenDark.cgColor
        imageV.layer.borderWidth = 2
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        return imageV
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,messageView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: -HANDLERS
    
    private func configureChat() {
        guard let chat = chat else { return }
        
        lastMessageItem = chat.lastMessage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        var path: String
        if chat.isGroupChat{
            titleLabel.text = chat.groupName
            path = chat.groupIconPath!
        }
        else{
            let otherUser = chat.users[chat.otherUser!]
            titleLabel.text = "\(otherUser.firstName) \(otherUser.lastName)"
            path = "Profile/\(otherUser.userId)"
        }
        
        if chat.lastMessage == nil {
            timeLabel.text = ""
        }
        else {
            timeLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        NetworkManager.shared.downloadImageWithPath(path: path) { image in
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
    
    @objc func checkBoxButtonTapped(){
        isChecked = !isChecked
        if isChecked {
            checkBox.setImage(ImageConstants.checkmarkSquare, for: .normal)
        } else {
            checkBox.setImage(ImageConstants.square, for: .normal)
        }
    }
    
    public func hideCheckBoxButton(isHide: Bool){
        if isHide{
            checkBox.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 50
            }, completion: nil)
        }
        else{
            checkBox.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = -15
            }, completion: nil)
        }
    }
    
    private func configure(){
        checkBox.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 1
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(messageLabel)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkBox.topAnchor.constraint(equalTo: topAnchor),
            checkBox.bottomAnchor.constraint(equalTo: bottomAnchor),
            checkBox.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -10),
            checkBox.widthAnchor.constraint(equalToConstant: 30),
            
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            stack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            
            timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])
    }
    
    private func checkLastMessage(){
        if lastMessageItem?.content == "" {
            messageLabel.text = "Photo"
            messageLabel.textColor = ColorConstants.customWhite
        } else {
            messageLabel.text = lastMessageItem?.content
        }
    }
}
