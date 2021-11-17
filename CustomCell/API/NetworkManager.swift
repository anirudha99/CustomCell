//
//  NetworkManager.swift
//  CustomCell
//
//  Created by Anirudha SM on 16/11/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct NetworkManager {
    static let shared = NetworkManager()
    
    func logInUsingFirebase(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        //Firebase
        print("Login button tapped")
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
