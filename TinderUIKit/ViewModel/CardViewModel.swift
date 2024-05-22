//
//  CardViewModel.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

class CardViewModel {
    let user: User
    private var imageIndex = 0
    
    let imageUrl : URL?
    let imageURLs : [String]
//    var imageToShow: String {
//        return user.images[imageIndex]
//    }
    
    init(user: User) {
        self.user = user
//        imageUrl = URL(string: user.profileImageUrl)
        self.imageURLs = user.imageURLs
        imageUrl = URL(string: imageURLs[0])
    }
    
    /// Advances to the next photo in the user's image collection.
    ///
    /// - Note: If the current image is the last one in the collection, this method has no effect.
    func showNextPhoto() {
        guard imageIndex < user.images.count - 1 else { return }
        imageIndex += 1
    }

    /// Shows the previous photo in the user's image collection.
    ///
    /// - Note: If the current image is the first one in the collection, this method has no effect.
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
    }

}
