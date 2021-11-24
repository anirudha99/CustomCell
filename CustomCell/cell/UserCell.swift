//
//  UserCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 22/11/21.
//

import UIKit

class UserCell: UITableViewCell {
    
    var delegate: ChatSelectedDelegate?
    let uid = NetworkManager.shared.getUID()
    
    var lastMessageItem: Message?{
        didSet{
            checkLastMessage()
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var select:Bool = false
    
    var normalView = UIView()
    var editView = UIView()
    var messageView = UIView()
    
    let nameLabel = CustomLabel(text: "")
    let messageLAbel = CustomLabel(text: "")
    let dateLabel = CustomLabel(text: "")
    
    var profileImage = CustomImageView(image:UIImage(systemName: "person.fill")!, height: 50, width: 50, cornerRadius: 25, color: .systemRed)
    
    var selectButton: UIButton = {
        let button = UIButton()
        //        button.setTitle("Select", for: .normal)
        button.setImage(ImageConstants.round, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        
        //        button.backgroundColor = .red
        
        return button
    }()
    
    lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, messageView])
        stack.spacing = 10
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    func selected(isSelect: Bool) {
        if isSelect {
            selectButton.setImage(ImageConstants.roundFill, for: .normal)
        } else {
            selectButton.setImage(ImageConstants.round, for: .normal)
        }
    }
    
    func animateView(open: Bool) {
        if open {
            selectButton.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 62
            }, completion: nil)
        } else {
            selectButton.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 0
            },completion: nil)
        }
    }
    
    @objc func selectChat() {
        print("Clicked")
    }
    
    func configureCell(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectChat))
        editView.addGestureRecognizer(tapGesture)
        
        
        //        selectButton.addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
        messageLAbel.numberOfLines = 1
        profileImage.backgroundColor = .gray
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        addSubview(messageView)
        addSubview(selectButton)
        addSubview(profileImage)
        addSubview(infoStack)
        addSubview(dateLabel)
        
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageLAbel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -20),
            selectButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImage.leftAnchor.constraint(equalTo: selectButton.rightAnchor, constant: 10),
            profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoStack.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10),
            infoStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60),
            dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
        ])
    }
    
    func checkLastMessage(){
        messageView.addSubview(messageLAbel)
        messageLAbel.text = lastMessageItem?.content
        messageLAbel.textAlignment = .left
        messageLAbel.widthAnchor.constraint(equalTo: infoStack.widthAnchor).isActive = true
    }
    
    @objc func handleSelect(sender: UIButton) {
        //        print("Selected")
        select = !select
        delegate?.chatSelected(isSelected: select)
        if select {
            selectButton.setImage(ImageConstants.roundFill, for: .normal)
        } else {
            selectButton.setImage(ImageConstants.round, for: .normal)
        }
    }
    
    
    
}
