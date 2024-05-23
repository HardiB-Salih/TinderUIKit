//
//  MatchViewViewModel.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//

import Foundation

struct MatchViewViewModel {
     private let currentUser: User
    let matchedUser: User
    
    let matchLableText: String
    var matchedUserImageURL: URL?
    var currentUserImageURL : URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLableText = "You and \(matchedUser.fullname.capitalized) have liked each other!"
        guard let currentImage = currentUser.imageURLs.first,
              let matchedImage = matchedUser.imageURLs.first else { return }
        currentUserImageURL = URL(string: currentImage)
        matchedUserImageURL = URL(string: matchedImage)
    }
}
