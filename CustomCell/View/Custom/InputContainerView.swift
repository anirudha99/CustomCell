//
//  InputContainerView.swift
//  CustomCell
//
//  Created by Anirudha SM on 11/11/21.
//

import Foundation
import UIKit

class InputContainerView : UIView {
    
    init(image: UIImage, textField: UITextField){
        super.init(frame: .zero)
        
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.borderColor = ColorConstants.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = ColorConstants.tealGreenDark
        addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        iv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textField)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor ).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


