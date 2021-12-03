//
//  NetworkManager.swift
//  CustomCell
//
//  Created by Anirudha SM on 16/11/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

struct NetworkManager {
    static let shared = NetworkManager()
    
    private let database = Database.database().reference()
    private let storage = Storage.storage()
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    let databaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    func getUID() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    func signup(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func addUser(user: ChatAppUser) {
        database.child("users").child(user.userId).setValue(user.dictionary)
    }
    
    func logInUsingFirebase(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        //Firebase
        print("Login button tapped")
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    func fetchCurrentUser( completion: @escaping(ChatAppUser) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.child("users").child(uid).observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                let email = dictionary["email"] as! String
                let firstname = dictionary["firstname"] as! String
                let lastname = dictionary["lastname"] as! String
                let profileURL = dictionary["profileURL"] as! String
                let uid = dictionary["uid"] as! String
                
                let user = ChatAppUser(userId: uid, firstName: firstname, lastName: lastname, emailAddress: email, profileURL: profileURL)
                completion(user)
            }
        }
    }
    
    func fetchAllUsers(completion: @escaping([ChatAppUser]) -> Void) {
        print("wdwewedwef")
        var users = [ChatAppUser]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.child("users").observe(.value) { snapshot in
            print("Fetching all users")
            if let result = snapshot.value as? [String: Any] {
                //                print(result)
                for userid in result.keys {
                    if userid == uid {
                        continue
                    }
                    let userData = result[userid] as! [String: Any]
                    
                    let email = userData["email"] as! String
                    let firstname = userData["firstname"] as! String
                    let lastname = userData["lastname"] as! String
                    let uid = userData["uid"] as! String
                    let profileURL = userData["profileURL"] as! String
                    let user = ChatAppUser(userId: uid, firstName: firstname, lastName: lastname, emailAddress: email, profileURL: profileURL)
                    
                    users.append(user)
                    
                }
                completion(users)
            }
        }
    }
    
    func addChat(user1: ChatAppUser, user2: ChatAppUser, id: String) {
        var userDictionary: [[String: Any]] = []
        
        userDictionary.append(user1.dictionary)
        userDictionary.append(user2.dictionary)
        let finalDic = ["Users" : userDictionary]
        
        database.child("Chats").child(id).setValue(finalDic)
    }
    
    func fetchChats(completion: @escaping([Chats]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.child("Chats").observe(.value) { snapshot in
            var chats = [Chats]()
            if let result = snapshot.value as? [String: [String: Any]] {
                for key in result.keys {
                    let value = result[key]!
                    var lastMessage: Message?
                    
                    let users = value["Users"] as! [[String: Any]]
                    let lastMessageDictionary = value["lastMessage"] as? [String: Any]
                    if lastMessageDictionary != nil {
                        
                        let sender = lastMessageDictionary!["sender"] as! String
                        let content = lastMessageDictionary!["content"] as! String
                        let timeString = lastMessageDictionary!["time"] as! String
                        let seen = lastMessageDictionary!["seen"] as! Bool
                        let imagePath = lastMessageDictionary!["imagePath"] as! String
                        
                        let time = databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = Message(sender: sender, content: content, time: time!, seen: seen, imagePath: imagePath)
//                        print(lastMessage)
                    } else {
                        lastMessage = nil
                    }
                    let user1 = users[0]
                    let user2 = users[1]
                    
                    let email1 = user1["email"] as! String
                    let firstname1 = user1["firstname"] as! String
                    let lastname1 = user1["lastname"] as! String
                    let uid1 = user1["uid"] as! String
                    let profileURL1 = user1["profileURL"] as! String
                    let firstUser = ChatAppUser(userId: uid1, firstName: firstname1, lastName: lastname1, emailAddress: email1, profileURL: profileURL1)
                    
                    let email2 = user2["email"] as! String
                    let firstname2 = user2["firstname"] as! String
                    let lastname2 = user2["lastname"] as! String
                    let uid2 = user2["uid"] as! String
                    let profileURL2 = user2["profileURL"] as! String
                    let secondUser = ChatAppUser(userId: uid2, firstName: firstname2, lastName: lastname2, emailAddress: email2, profileURL: profileURL2)
                    
                    var otherUser: Int
                    
                    if uid1 == uid {
                        otherUser = 1
                    } else {
                        otherUser = 0
                    }
                    let id = key
                    let chat = Chats(chatId: id, users: [firstUser, secondUser], lastMessage: lastMessage, messages: [], otherUser: otherUser)
                    if firstUser.userId == uid || secondUser.userId == uid {
                        chats.append(chat)
                    }
                }
                let sortedChats = chats.sorted()
                completion(sortedChats)
            }
        }
    }
    
    func addMessages(messages: [Message], lastMessage: Message, id: String){
        var lastMessageObj = lastMessage
        let dateString = databaseDateFormatter.string(from: lastMessage.time)
        lastMessageObj.dateString = dateString
        
        let lastMessageDictionary = lastMessageObj.dictionary
        var messageDictionary: [[String:Any]] = []
        
        for var message in messages {
            let dateString = databaseDateFormatter.string(from: message.time)
            message.dateString = dateString
            messageDictionary.append(message.dictionary)
        }
        let finalDictionary = ["lastMessage": lastMessageDictionary]
        
        database.child("Chats").child(id).updateChildValues(finalDictionary)
        database.child("Chats").child(id).child("messages").childByAutoId().setValue(lastMessageDictionary)
        
    }
    
    func fetchMessages(chatId: String, completion: @escaping([Message]) -> Void) {
        database.child("Chats").child("\(chatId)/messages").observe(.value) { snapshot in
            var resultArray: [Message] = []
            if let result = snapshot.value as? [String: [String: Any]] {
                let sortedKeyArray = result.keys.sorted()
                for id in sortedKeyArray {
                    let message = result[id]!
                    resultArray.append(createMessageObject(dictionary: message , id: id))
                }
                completion(resultArray)
            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping(UIImage) -> Void) {
        let result = storage.reference(forURL: url)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                completion(resultImage)
            }
        }
    }
    
    func downloadImageWithPath(path: String, completion: @escaping(UIImage) -> Void) {
        let result = storage.reference(withPath: path)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                completion(resultImage)
            }
        }
    }
    
    func createMessageObject(dictionary: [String: Any], id: String) -> Message {
        let sender = dictionary["sender"] as! String
        let content = dictionary["content"] as! String
        let timeString = dictionary["time"] as! String
        let seen = dictionary["seen"] as! Bool
        let time = databaseDateFormatter.date(from: timeString)
        let imagePath = dictionary["imagePath"] as! String
        return Message(sender: sender, content: content, time: time!, seen: seen, id: id, imagePath: imagePath)
    }
    
    func logout() -> Bool {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            return true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        return false
    }
}
