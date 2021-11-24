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
        //        cbutton.backgroundColor = .blue
        cbutton.setImage(UIImage(systemName: "square"), for: .normal)
        cbutton.tintColor = .systemRed
        return cbutton
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //        label.backgroundColor = .brown
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Sample title text ererrereeeereerereerer"
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        //        label.backgroundColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Sample text"
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        label.text = dateFormatter.string(from: Date())
        //        label.text = "33:33"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .clear
        return label
    }()
    
    let iconImageView : UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        imageV.image = UIImage(systemName: "person.fill")
        imageV.tintColor = .systemRed
        imageV.layer.cornerRadius = 20
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.layer.borderWidth = 2
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        return imageV
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,messageLabel])
        stack.axis = .vertical
        stack.spacing = 5
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configureChat(){
        guard let chat = chat else { return }
        let otherUser = chat.users[chat.otherUser!]
        titleLabel.text = "\(otherUser.firstName) \(otherUser.lastName)"
        //            print(chat.chatId)
        lastMessageItem = chat.lastMessage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            timeLabel.text = ""
        }
        else {
            timeLabel.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        var fetchUser: ChatAppUser
        if chat.otherUser == 0 {
            fetchUser = chat.users[0]
        } else {
            fetchUser = chat.users[1]
        }
        NetworkManager.shared.downloadImageWithPath(path: "Profile/\(fetchUser.userId)") { image in
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
    
    @objc func checkBoxButtonTapped(){
        print("Button tapped")
        
        isChecked = !isChecked
        if isChecked {
            checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    func hideCheckBoxButton(isHide: Bool){
        if isHide{
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 50
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = -15
            }, completion: nil)
        }
    }
    
    func configure(){
        //        layer.cornerRadius = 5
        //        layer.borderWidth = 2
        
        checkBox.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75).isActive = true
        
        NSLayoutConstraint.activate([
            
            checkBox.topAnchor.constraint(equalTo: topAnchor),
            checkBox.bottomAnchor.constraint(equalTo: bottomAnchor),
            checkBox.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -10),
            checkBox.widthAnchor.constraint(equalToConstant: 30),
            //
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            
            timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
    }
    
    func checkLastMessage(){
        messageView.addSubview(messageLabel)
        messageLabel.text = lastMessageItem?.content
        messageLabel.textAlignment = .left
        messageLabel.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }
}
