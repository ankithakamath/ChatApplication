
//
//  StorageManager.swift
//  ChatApp
//
//  Created by Ankitha Kamath on 17/11/21.
//
import Foundation
import FirebaseStorage

final class Storagemanager{
    
    static let shared = Storagemanager()
    private let storage = Storage.storage()
    
    
    public typealias uploadPictureCompletion = (Result<String,Error>) -> Void
    
    //upload pic to firebase and gets url
    static func uploadImageToDb(image: UIImage, uid: String, completion: @escaping(String) -> Void) {
        
        let storage = Storage.storage().reference()
        
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
    
    
    func downloadImage(url: String, completion: @escaping (UIImage) -> Void){
        
        let result = storage.reference(forURL: url)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                let resultImage: UIImage! = UIImage(data: data)
                completion(resultImage)
            }
        }
    }
    
    struct ImageUploader {
        static func uploadImage(image: UIImage, path: String, completion: @escaping(String) -> Void) {
            
            let storage = Storage.storage().reference()
            
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            
            storage.child(path).putData(imageData, metadata: nil) { _, error in
                guard error == nil else { return }
                
                storage.child(path).downloadURL { url, error in
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
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
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
}
