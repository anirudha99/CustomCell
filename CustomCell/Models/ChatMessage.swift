//
//  Chat.swift
//  CustomCell
//
//  Created by Anirudha SM on 19/11/21.
//

import Foundation

struct Message {
    var sender: String
    var content: String
    var time: Date
    var seen: Bool
    var dateString: String?
    var id: String?
    var imagePath: String?
    
    var dictionary: [String: Any] {
        return [
            "sender": sender,
            "content": content,
            "time": dateString ?? Date(),
            "seen": seen,
            "imagePath": imagePath ?? ""
        ]
    }
}
