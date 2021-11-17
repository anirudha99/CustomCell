//
//  ConversationCell.swift
//  CustomCell
//
//  Created by Anirudha SM on 09/11/21.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    
    
    
    //MARK: - Properties
    let titleLabel : UILabel = {
        let label = UILabel()
//        label.backgroundColor = .brown
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Sample title text ererrereeeereerereererere"
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
        imageV.layer.cornerRadius = 20
        imageV.layer.borderColor = UIColor.black.cgColor
        imageV.layer.borderWidth = 2
        imageV.layer.masksToBounds = false
        imageV.clipsToBounds = true
        return imageV
    }()    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(){
        layer.cornerRadius = 5
        layer.borderWidth = 2
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
//        iconImageView.layer.cornerRadius = 15
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [titleLabel,messageLabel])
        stack.axis = .vertical
        stack.spacing = 5
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75).isActive = true
        
        NSLayoutConstraint.activate([
            
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),

//            timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            timeLabel.topAnchor.constraint(equalTo: topAnchor,constant: 20),
            timeLabel.leftAnchor.constraint(equalTo: stack.rightAnchor, constant: 7)
//            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            
            ])
       
    }
}
