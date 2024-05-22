//
//  User.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import Firebase

struct User {
    var fullname : String
    var age: Int
    var email: String
    let uid: String
    var imageURLs: [String]
    let createdAt: Timestamp
    var images: [UIImage]
    var profession: String
    var bio: String
    var minSeakingAge: Int
    var maxSeakingAge: Int
    
    
    
    //MARK: - Computed properties
    var attributedNameWithAge : NSMutableAttributedString {
        let attributedText = fullname.mutableAttributedString(font: UIFont.systemFont(ofSize: 32, weight: .heavy))
        attributedText.append("  \(age)".attributedString(font: UIFont.systemFont(ofSize: 24)))
        return attributedText
    }
    
    init(dictionary: [String: Any]) {
        self.fullname = dictionary[.fullname] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.age = dictionary[.age] as? Int ?? 0
        self.uid = dictionary[.uid] as? String ?? ""
        self.imageURLs = dictionary[.imageURLs] as? [String] ?? []
        self.createdAt = dictionary[.createdAt] as? Timestamp ?? Timestamp()
        self.images = dictionary[.images] as? [UIImage] ?? []
        self.profession = dictionary[.profession] as? String ?? ""
        self.bio = dictionary[.bio] as? String ?? ""
        self.minSeakingAge = dictionary[.minSeakingAge] as? Int ?? 18
        self.maxSeakingAge = dictionary[.maxSeakingAge] as? Int ?? 40


    }
}

extension String {
    static let fullname = "fullname"
    static let age = "age"
    static let email = "email"
    static let uid = "uid"
    static let imageURLs = "imageURLs"
    static let createdAt = "createdAt"
    static let images = "images"
    static let profession = "profession"
    static let bio = "bio"
    static let minSeakingAge = "minSeakingAge"
    static let maxSeakingAge = "maxSeakingAge"
}
