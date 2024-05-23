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
    case currentUserNotAuthenticated
    
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
        case .currentUserNotAuthenticated:
            return "Current User Not Authenticated"
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
    
    //fetchSwipes Method:
    //
    //This method fetches a dictionary called swipeUserIdes where:
    //Keys: User IDs that the current user has swiped on.
    //Values: Booleans indicating the swipe status (e.g., true for liked, false for disliked).
    //fetchUsers Method:
    //
    //This method is responsible for fetching users within a specified age range.
    //After defining the query, it calls fetchSwipes to get the list of swiped user IDs.
    //Filtering Logic:
    //
    //Once the swipeUserIdes dictionary is retrieved, the query to fetch users is executed.
    //For each user document returned by the query, the method:
    //Converts the document data to a User object.
    //Checks if the user is the current user (using user.uid != currentUid). If so, it skips this user.
    //Checks if the user ID is present in the swipeUserIdes dictionary (swipeUserIdes[user.uid] == nil). If the user ID is present, it means the current user has already swiped on this user, and the user is skipped.

    
    static func fetchUsers(forUser user: User, completion: @escaping (Result<[User], Error>) -> Void) {
        var users = [User]()
        let minSeakingAge = user.minSeakingAge
        let maxSeakingAge = user.maxSeakingAge
        
        // Create a query to fetch users within the specified age range
        let query = USER_COLLECTION
            .whereField(.age, isGreaterThanOrEqualTo: minSeakingAge)
            .whereField(.age, isLessThanOrEqualTo: maxSeakingAge)
        
        // Check if the user has swiped on any other users
        fetchSwipes { swipeUserIdes in
            // Execute the query to get user data
            query.getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.failure(ServicesError.failedToFetchUsers))
                    return
                }
                
                guard let currentUid = Auth.auth().currentUser?.uid else {
                    completion(.failure(ServicesError.currentUserNotAuthenticated))
                    return
                }
                
                // Process each document to create User objects
                documents.forEach { document in
                    let user = User(dictionary: document.data())
                    
                    // Skip the current user
                    guard user.uid != currentUid else { return }
                    
                    // Skip users that the current user has already swiped on
                    guard swipeUserIdes[user.uid] == nil else { return }
                    
                    // Add the user to the list of fetched users
                    users.append(user)
                }
                
                // Return the list of users in the completion handler
                completion(.success(users))
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
    
    
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: (CompletionHandler<Error?>)? ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //        let shouldLike = isLike ? 1 : 0
        
        SWIPES_COLLECTION.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike]
            if snapshot?.exists == true {
                SWIPES_COLLECTION.document(uid).updateData(data, completion: completion)
            } else {
                SWIPES_COLLECTION.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping CompletionHandler<Bool>) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false) // Return false if user is not logged in
            return
        }
        
        SWIPES_COLLECTION.document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error checking for match: \(error)")
                completion(false) // Handle error
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(false) // Return false if no data exists
                return
            }
            
            guard let didMatch = data[currentUserId] as? Bool else {
                completion(false) // Return false if didMatch is not a Bool
                return
            }
            
            completion(didMatch)
        }
    }
    
    
    private static func fetchSwipes(completion: @escaping CompletionHandler<[String: Bool]>) {
        // Ensure the current user is authenticated
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        // Fetch the swipe data for the current user
        SWIPES_COLLECTION.document(currentUserId).getDocument { snapshot, error in
            // Extract the data as a dictionary of [String: Bool]
            guard let data = snapshot?.data() as? [String: Bool] else {
                // If there's no data, return an empty dictionary
                completion([String: Bool]())
                return
            }
            
            // Return the swipe data
            completion(data)
        }
    }

    
    static func uploadMatch(currentUser: User, matchUser: User) {
        guard let matchUserProfileImageUrl = matchUser.imageURLs.first else { return }
        guard let currentUserProfileImageUrl = currentUser.imageURLs.first else { return }
        print("uploadMatch : \(matchUserProfileImageUrl) & \(currentUserProfileImageUrl)")
        
        let matchUserData: [String: Any] = [
            .uid : matchUser.uid,
            .profileImageUrl: matchUserProfileImageUrl,
            .fullname: matchUser.fullname
        ]
        
        MATCHES_MESSAGE_COLLECTION.document(currentUser.uid).collection("matches").document(matchUser.uid).setData(matchUserData)
        
        let currentUserData: [String: Any] = [
            .uid : currentUser.uid,
            .profileImageUrl: currentUserProfileImageUrl,
            .fullname: currentUser.fullname
        ]
        
        MATCHES_MESSAGE_COLLECTION.document(matchUser.uid).collection("matches").document(currentUser.uid).setData(currentUserData)
    }
    
    
    
    
    static func fetchMatches(completion: @escaping CompletionHandler<[Match]>) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        MATCHES_MESSAGE_COLLECTION.document(currentUserId).collection("matches").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching match: \(error)")
                return
            }
            
            guard let data = snapshot else { return }
            let matches = data.documents.map({ Match(dict: $0.data()) })
            completion(matches)
        }
    }
}


