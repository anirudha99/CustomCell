//
//  Constants.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit

struct ImageConstants {
    static let appIcon = "chatapplogo"
    static let person = UIImage(systemName: "person.circle")
    static let personFill = UIImage(systemName: "person.fill")
    static let lockFill = UIImage(systemName: "lock.fill")
    static let roundFill = UIImage(systemName: "circle.fill")
    static let round = UIImage(systemName: "circle")
    static let envelope = UIImage(systemName: "envelope.fill")
    static let sendButton =  UIImage(systemName: "paperplane.fill")
    static let square = UIImage(systemName: "square")
    static let picture = UIImage(systemName: "photo.fill")
    static let groupPhoto = UIImage(systemName: "person.3.fill")
    static let info = UIImage(systemName: "info.circle.fill")
    static let messageFill = UIImage(systemName: "message.fill")
    static let checkmarkSquare  = UIImage(systemName: "checkmark.square")

}

struct MessageConstants {
    static let emailInvalid = "Please Enter a Valid Email Address"
    static let passwordInvalid = "Password is Invalid. Password must contain atleast 8 character with 1 number and 1 special character"
    static let usernameInvalid = "User Name must be atleast 3 Characters"
    static let profilePictureInvalid = "Please Upload a Profile Picture"
    static let groupPhotoInvalid = "Please Upload a Group Picture"
    static let groupNameInvalid = "Please Enter a Valid Group Name"
    static let minimumGroupMemberError = "Please select more than 1 user"
    
}

struct FontConstants {
    static let textFont = UIFont(name: "San Francisco Pro Display", size: 24)
    static let labelFont = UIFont(name: "San Francisco", size: 16)
    static let senderTextfont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let textfontName = UIFont.systemFont(ofSize: 18, weight: .light)
}

struct ColorConstants {
    static let tealGreen = UIColor(red: 18/255.0, green: 140/255.0, blue: 126/255.0, alpha: 1.0)
    static let tealGreenDark = UIColor(red: 7/255.0, green: 94/255.0, blue: 84/255.0, alpha: 1.0)
    static let lightGreen = UIColor(red: 37/255.0, green: 211/255.0, blue: 102/255.0, alpha: 1.0)
    static let teaGreen = UIColor(red: 220/255.0, green: 248/255.0, blue: 198/255.0, alpha: 1.0)
    static let whiteChocolate = UIColor(red: 236/255.0, green: 229/255.0, blue: 221/255.0, alpha: 1.0)
    static let blue = UIColor(red: 52/255.0, green: 183/255.0, blue: 241/255.0, alpha: 1.0)
    static let customWhite = UIColor(red: 236/255.0, green: 229/255.0, blue: 221/255.0, alpha: 1.0)
    static let white = UIColor(white: 1, alpha: 1)
    static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let background = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
    static let navigationBackground = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
    static let grayLight = UIColor(red: 35/255, green: 45/255, blue: 54/255, alpha: 1)
    static let lightGrayTime = UIColor(red: 157/255, green: 165/255, blue: 172/255, alpha: 1)

}
