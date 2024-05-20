//
//  User.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

struct User {
    var name : String
    var age: Int
    var images: [UIImage]
    
    
    //MARK: - Computed properties
    var attributedNameWithAge : NSMutableAttributedString {
        let attributedText = name.mutableAttributedString(font: UIFont.systemFont(ofSize: 32, weight: .heavy))
        attributedText.append("  \(age)".attributedString(font: UIFont.systemFont(ofSize: 24)))
        return attributedText
    }
}
