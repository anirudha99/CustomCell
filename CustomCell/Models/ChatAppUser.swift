//
//  ChatAppUser.swift
//  CustomCell
//
//  Created by Anirudha SM on 18/11/21.
//

import Foundation
import UIKit

struct ChatAppUser{
    
    let userId: String
    let firstName: String
    let lastName: String
    let emailAddress: String
    var profileURL: String
    
    var dictionary: [String: Any] {
        return [
            "firstname": firstName,
            "lastname" : lastName,
            "email": emailAddress,
            "profileURL": profileURL,
            "uid": userId
        ]
    }
}
