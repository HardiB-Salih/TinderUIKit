//
//  AuthServices.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import Firebase


struct AuthCredential {
    let email: String
    let fullname: String
    let password: String
    let profileImage: UIImage
}

enum AuthServicesError: Error {
    case registrationError
    
    var localizedDescription: String {
        switch self {
        case .registrationError:
            return "Failed to get user after authentication"
        }
    }
}

struct AuthServices {
    static func registerUser(withCredential credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        // 1. Upload Profile Picture Asynchronously
        Services.uploadImage(with: credential.profileImage) { profilePictureResult in
            switch profilePictureResult {
            case .success(let profileImageUrl):
                // 2. Create User in Firebase Authentication
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { authResult, error in
                    if let error = error {
                        // Handle authentication error
                        completion(error)
                        return
                    }
                    
                    guard let uid = authResult?.user.uid else {
                        completion(AuthServicesError.registrationError)
                        return
                    }
                    
                    // 3. Store User Data in Firestore
                    let fireStoreData: [String: Any] = [
                        .uid: uid,
                        .age: 18,
                        .email: credential.email,
                        .fullname: credential.fullname,
                        .imageURLs: [profileImageUrl],
                        .createdAt: Timestamp(date: Date())
                    ]
                    
                    USER_COLLECTION.document(uid).setData(fireStoreData) { error in
                        if let error = error {
                            // Handle Firestore error
                            completion(error)
                        } else {
                            // Registration successful
                            completion(nil)
                        }
                    }
                }
                
            case .failure(let error):
                // Handle profile picture upload error
                completion(error)
            }
        }
    }
    
    
    static func signIn(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle the error
                completion(.failure(error))
            } else if let authResult = authResult {
                // Success
                completion(.success(authResult))
            }
        }
    }
    
    
    static func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
