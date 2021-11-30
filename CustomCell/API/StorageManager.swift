//
//  StorageManager.swift
//  CustomCell
//
//  Created by Anirudha SM on 16/11/21.
//

import Foundation
import FirebaseStorage
import Firebase

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String,Error>) -> Void
    
    //function uploads profile picture data as png data and gets the url to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else{
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    //custom errors for the uploading and downloading
    public enum StorageErrors: Error{
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    //function gets the url of the profile picture
    public func downloadURL(for path: String,  completion: @escaping (Result<URL,Error>)->Void){
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url  = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl ))
                return
            }
            completion(.success(url))
        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        let storage = Storage.storage().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        storage.child("Profile").child(uid).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            
            storage.child("Profile").child(uid).downloadURL { url, error in
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
