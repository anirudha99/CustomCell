//
//  API.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
}

//MARK: - Account

extension DatabaseManager{
    
    public func validateIfUserExists(with email: String, completion: @escaping((Bool) -> Void)){
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertUser(with user: ChatAppUser){
        database.child(user.emailAddress).setValue(["firstName": user.firstName,"lastName": user.lastName])
    }
}


struct ChatAppUser{
    let firstName: String
    let lastName: String
    let emailAddress: String
    //    let profilePictureURL: String
}
