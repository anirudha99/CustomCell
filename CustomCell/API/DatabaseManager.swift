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
    
    //to use this in usercollection
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

//MARK: - Account

extension DatabaseManager{
    
    public func createNewConversations(with otherUserEmail: String, firstMessage: String, completion: @escaping(Bool) -> Void){
        
    }
    
    public func getAllConversations(){
        
    }
    
    public func getAllMessagesForConversation(){
        
    }
    
    public func sendMessage(){
        
    }
    
    public func validateIfUserExists(with email: String, completion: @escaping((Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //inserting user into firebase
//    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void){
//        database.child(user.safeEmail).setValue(["uid": user.userId ,"firstName": user.firstName,"lastName": user.lastName]) { error, _ in
//            guard error == nil else {
//                print("Failed to insert user")
//                completion(false)
//                return
//            }
//            
//            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
//                if var usersCollection = snapshot.value as? [[String:String]]{
//                    //append users into user list
//                    let newElement = [ "name": user.firstName + " " + user.lastName,
//                                       "uid": user.userId,
//                                       "email": user.safeEmail
//                    ]
//                    usersCollection.append(newElement)
//                    self.database.child("users").setValue(usersCollection) { error, _ in
//                        guard error == nil else{
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    }
//                }
//                else{
//                    //create list and add into new user list if no user present
//                    let newCollection : [[String:String]] = [
//                        [
//                            "name": user.firstName + " " + user.lastName,
//                            "uid": user.userId,
//                            "email": user.safeEmail
//                        ]
//                    ]
//                    self.database.child("users").setValue(newCollection) { error, _ in
//                        guard error == nil else{
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }
    
    //function gets all the users in userCollection list
    public func getAllUsers(completion: @escaping(Result<[[String:String]],Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String:String]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    //custom error if not fetched
    public enum DatabaseError: Error{
        case failedToFetch
    }
    
}



