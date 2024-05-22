//
//  Services.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import FirebaseStorage
import Firebase

public typealias CompletionHandler<T> = (T) -> Void
public typealias ResultCompletion<T> = (Result<T, Error>) -> Void

enum ServicesError: Error {
    case failedToConvertToJPEG
    case downloadURLError
    case failedToFetchUser
    case failedToFetchUsers
    
    var localizedDescription: String {
        switch self {
        case .failedToConvertToJPEG:
            return "Failed to convert image to JPEG data."
        case .downloadURLError:
            return "Failed to get download URL"
        case .failedToFetchUser:
            return "Faild to fetch user info"
        case .failedToFetchUsers:
            return "Faild to fetch all user info"
        }
    }
}


struct Services {
    
    static func fetchUser(with uid: String, completion: @escaping ResultCompletion<User> ) {
        USER_COLLECTION.document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data()  else {
                completion(.failure(ServicesError.failedToFetchUser))
                return
            }
            let user = User(dictionary: data)
            completion(.success(user))
        }
    }
    
    static func fetchUsers(completion: @escaping ResultCompletion<[User]>) {
        var users = [User]()
        USER_COLLECTION.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(ServicesError.failedToFetchUsers))
                return
            }
            
            documents.forEach { document in
                let user =  User(dictionary: document.data())
                users.append(user)
                
                if users.count == documents.count {
                    guard let currentUid = Auth.auth().currentUser?.uid else { return }
                    let usersExcludingMe = users.filter { $0.uid != currentUid }
                    completion(.success(usersExcludingMe))
                }
            }
        }
    }
    
    static func updateUserData(user: User, completion: @escaping CompletionHandler<Error?> ) {
        let data : [String: Any] = [
            .fullname: user.fullname,
            .imageURLs: user.imageURLs,
            .age: user.age,
            .bio: user.bio,
            .profession: user.profession,
            .maxSeakingAge: user.maxSeakingAge,
            .minSeakingAge: user.minSeakingAge
        ]
        
        USER_COLLECTION.document(user.uid).updateData(data, completion: completion)
    }
    
    static func uploadImage(with image: UIImage,
                            fileName: String = "profile",
                            completion: @escaping(Result<String, Error>) -> Void ) {
        guard let data = image.jpegData(compressionQuality: 0.25) else {
            completion(.failure(ServicesError.failedToConvertToJPEG))
            return
        }
        
        let storage = Storage.storage().reference()
        let stringId = UUID().uuidString
        let imageReference = storage.child("/images/\(fileName)/\(stringId).jpeg")
        
        imageReference.putData(data, metadata: nil) { _, error in
            if let error = error {
                // Handle the error
                completion(.failure(error))
                return
            }
            
            // Get the download URL
            imageReference.downloadURL { url, error in
                if let error = error {
                    // Handle the error
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    // Handle the error
                    completion(.failure(ServicesError.downloadURLError))
                    return
                }
                
                let urlString = downloadURL.absoluteString
                completion(.success(urlString))
            }
        }
    }
    
    static func updateUserImageUrlData(user: User, completion: @escaping CompletionHandler<Error?> ) {
        let data : [String: Any] = [
            .imageURLs: user.imageURLs,
        ]
        USER_COLLECTION.document(user.uid).updateData(data, completion: completion)
    }
    
    
    static func deleteFileFromFirebaseStorage(downloadUrl: String) {
        //    completion: @escaping (Error?) -> Void
        // Step 1: Extract the path from the download URL
        func extractPathFromUrl(_ url: String) -> String? {
            let pattern = "https://firebasestorage.googleapis.com:443/v0/b/tinderuikit.appspot.com/o/"
            guard let range = url.range(of: pattern) else { return nil }
            let pathPart = url[range.upperBound...]
            
            if let queryIndex = pathPart.range(of: "?")?.lowerBound {
                let encodedPath = String(pathPart[..<queryIndex])
                return encodedPath.removingPercentEncoding
            }
            return nil
        }
        
        guard let filePath = extractPathFromUrl(downloadUrl) else {
            //            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid download URL"]))
            print("Invalid download URL")
            return
        }
        
        print("File Path is: \(filePath)")
        
        // Step 2: Create a reference to the file
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(filePath)
        
        // Step 3: Delete the file
        fileRef.delete { error in
            //            completion(error)
            if let error = error {
                print("Error deleting file: \(error.localizedDescription)")
            } else {
                print("File deleted successfully")
            }
        }
    }
}
