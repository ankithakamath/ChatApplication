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
    
    private let storage = Storage.storage().reference()
    
    public typealias uploadPictureCompletion = (Result<String,Error>) -> Void
    
    //upload pic to firebase and gets url
//    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping uploadPictureCompletion ) {
//        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
//            guard error == nil else {
//                print("failed to upload picture")
//                completion(.failure(StorageErrors.failedToUpload))
//                return
//            }
//            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
//                guard let url = url else {
//                    print("Failed to download url")
//                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                    return
//                }
//                let urlString = url.absoluteString
//                print("download url returned: \(urlString)")
//                completion(.success(urlString))
//            })
//        })
//    }
    
    struct ImageUploader {
            static func uploadImage(image: UIImage, uid: String, completion: @escaping(String) -> Void) {
                
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
        }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
//    public func downloadURL(for path: String, completion: @escaping (Result<URL,Error>) -> Void){
//        let reference = storage.child(path)
//        reference.downloadURL(completion: { url, error in
//            guard let url = url, error == nil  else {
//                completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                return
//            }
//            completion(.success(url))
//        })
//    }
//}
    func downloadImageWithPath(path: String, completion: @escaping(UIImage) -> Void) {
           let storage = Storage.storage()
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
