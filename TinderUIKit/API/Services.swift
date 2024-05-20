//
//  Services.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import FirebaseStorage

public typealias CompletionHandler<T> = (T) -> Void
public typealias ResultCompletion<T> = (Result<T, Error>) -> Void


struct Services {

    static func uploadProfilePicture(with image: UIImage,
                                     fileName: String = "profile",
                                     completion: @escaping(Result<String, Error>) -> Void ) {
        guard let data = image.jpegData(compressionQuality: 0.25) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])))
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
                    completion(.failure(NSError(domain: "DownloadURLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                    return
                }

                let urlString = downloadURL.absoluteString
                completion(.success(urlString))
            }
        }
    }
}
