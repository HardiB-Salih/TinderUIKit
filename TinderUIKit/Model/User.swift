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
    var profession: String
    var bio: String
    var minSeakingAge: Int
    var maxSeakingAge: Int
    
    
    
    //MARK: - Computed properties
    func attributedNameWithAge(textColor: UIColor = .white) -> NSMutableAttributedString {
        let attributedText = fullname.capitalized.mutableAttributedString(font: .systemFont(of: .title1, weight: .heavy), textColor: textColor)
        attributedText.append("  \(age)".attributedString(font: .systemFont(of: .title3, weight: .light), textColor: textColor))
        return attributedText
    }
    
    init(dictionary: [String: Any]) {
        self.fullname = dictionary[.fullname] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.age = dictionary[.age] as? Int ?? 0
        self.uid = dictionary[.uid] as? String ?? ""
        self.imageURLs = dictionary[.imageURLs] as? [String] ?? []
        self.createdAt = dictionary[.createdAt] as? Timestamp ?? Timestamp()
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
    static let profession = "profession"
    static let bio = "bio"
    static let minSeakingAge = "minSeakingAge"
    static let maxSeakingAge = "maxSeakingAge"
}
