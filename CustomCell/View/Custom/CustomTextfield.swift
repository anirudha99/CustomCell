//
//  CustomTextfield.swift
//  CustomCell
//
//  Created by Anirudha SM on 11/11/21.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, color: UIColor){
        super.init(frame: .zero)
        
        font = UIFont.systemFont(ofSize: 18)
        textColor = color
        self.placeholder = placeholder
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset.height = -3
        autocorrectionType = .no
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
