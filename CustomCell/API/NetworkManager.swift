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
    
    func getUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func logInUsingFirebase(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        //Firebase
        print("Login button tapped")
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: completion)
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
