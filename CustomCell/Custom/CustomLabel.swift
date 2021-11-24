//
//  CustomLabel.swift
//  CustomCell
//
//  Created by Anirudha SM on 11/11/21.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    
    init(text: String){
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textColor = .black
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomImageView: UIImageView {
    
    init(image: UIImage, height: CGFloat, width: CGFloat, cornerRadius: CGFloat, color: UIColor) {
        super.init(frame: .zero)
        self.image = image
        layer.cornerRadius = cornerRadius
        tintColor = color
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
