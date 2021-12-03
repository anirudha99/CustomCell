//
//  StorageManager.swift
//  CustomCell
//
//  Created by Anirudha SM on 16/11/21.
//

import Foundation
import FirebaseStorage
import Firebase

struct ImageUploader {
    
    static func uploadImage(image: UIImage, name: String, completion: @escaping(String) -> Void) {
        let storage = Storage.storage().reference()
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        storage.child(name).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            storage.child("Profile").child(name).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                completion(urlString)
            }
        }
    }
}
