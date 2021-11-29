//
//  Constants.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit

struct ImageConstants {
    static let appIcon = "chatAppicon"
    static let person = UIImage(systemName: "person.circle")
    static let roundFill = UIImage(systemName: "circle.fill")
    static let round = UIImage(systemName: "circle")
    static let sendButton =  UIImage(systemName: "paperplane.fill")
    static let square = UIImage(systemName: "square")

}

struct MessageConstants {
    static let emailInvalid = "Email is Invalid. Please Enter a Valid Email ID"
    static let passwordInvalid = "Password is Invalid. Password must contain atleast 8 character with 1 number and 1 special character"
    static let usernameInvalid = "User Name must be atleast 3 Characters"
    static let profilePictureInvalid = "Please Upload a Profile Picture"
}

public protocol SenderType {
    var senderId: String { get }
    var displayName: String { get }
}

public protocol MessageType {
    
    var sender: SenderType { get }
    var messageId: String { get }
    var sentDate: Date { get }
    var kind: MessageKind { get }
    
}

public enum MessageKind {
    case text(String)
//    case photo(MediaItem)
//    case video(MediaItem)
    
}
