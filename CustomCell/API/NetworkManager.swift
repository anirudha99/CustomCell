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
    private let imageCache = NSCache<AnyObject, UIImage>()
    
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
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func resetPasswordWithEmail(email: String, completion: @escaping(String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            completion("LinkSent")
        }
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
        var users = [ChatAppUser]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.child("users").observe(.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
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
    
    func addChat(users: [ChatAppUser], id: String, isGroupChat: Bool, groupName: String?, groupIconPath: String?) {
        var userDictionary: [[String: Any]] = []
        var finalDictionary: [String: Any]
        
        for user in users {
            userDictionary.append(user.dictionary)
        }
        
        if isGroupChat {
            finalDictionary = ["users": userDictionary,
                               "isGroupChat": isGroupChat,
                               "groupName": groupName!,
                               "groupIconPath": groupIconPath!]
        } else {
            finalDictionary = ["users": userDictionary,
                               "isGroupChat": isGroupChat]
        }
        database.child("Chats").child(id).setValue(finalDictionary)
    }
    
    func fetchChats(completion: @escaping([Chats]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        database.child("Chats").observe(.value) { snapshot in
            var chats = [Chats]()
            if let result = snapshot.value as? [String: [String: Any]] {
                for key in result.keys {
                    let value = result[key]!
                    var lastMessage: Message?
                    
                    let users = value["users"] as! [[String: Any]]
                    let lastMessageDictionary = value["lastMessage"] as? [String: Any]
                    let isGroupChat = value["isGroupChat"] as! Bool
                    
                    if lastMessageDictionary != nil {
                        let sender = lastMessageDictionary!["sender"] as! String
                        let content = lastMessageDictionary!["content"] as! String
                        let timeString = lastMessageDictionary!["time"] as! String
                        let seen = lastMessageDictionary!["seen"] as! Bool
                        let imagePath = lastMessageDictionary!["imagePath"] as! String
                        let time = databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = Message(sender: sender, content: content, time: time!, seen: seen, imagePath: imagePath)
                    } else {
                        lastMessage = nil
                    }
                    var usersArray: [ChatAppUser] = []
                    var uidArray: [String] = []
                    let id = key
                    var chat: Chats
                    
                    for user in users {
                        let userObject = createUserObject(dictionary: user)
                        usersArray.append(userObject)
                        uidArray.append(userObject.userId)
                    }
                    if isGroupChat {
                        let groupName = value["groupName"] as! String
                        let groupIconPath = value["groupIconPath"] as! String
                        
                        chat = Chats(chatId: id, users: usersArray, lastMessage: lastMessage, messages: [], isGroupChat: isGroupChat, groupName: groupName, groupIconPath: groupIconPath)
                        
                    }
                    else {
                        var otherUser: Int
                        if usersArray[0].userId == uid {
                            otherUser = 1
                        } else {
                            otherUser = 0
                        }
                        
                        chat = Chats(chatId: id, users: usersArray, lastMessage: lastMessage, messages: [], otherUser: otherUser, isGroupChat: isGroupChat)
                    }
                    if uidArray.contains(uid) {
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
        if let cachedImage = self.imageCache.object(forKey: path as AnyObject){
            completion(cachedImage)
            return
        }
        let result = storage.reference(withPath: path)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                self.imageCache.setObject(resultImage, forKey: path as AnyObject)
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
    
    func createUserObject(dictionary: [String: Any]) -> ChatAppUser {
        let email = dictionary["email"] as! String
        let firstname = dictionary["firstname"] as! String
        let lastname = dictionary["lastname"] as! String
        let uid = dictionary["uid"] as! String
        let profileURL = dictionary["profileURL"] as! String
        return ChatAppUser(userId: uid, firstName: firstname, lastName: lastname, emailAddress: email, profileURL: profileURL)
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
