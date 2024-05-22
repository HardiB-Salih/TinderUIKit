//
//  ProfileViewModel.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/22/24.
//

import UIKit

struct ProfileViewModel {
    private let user: User
    
    var imageCount: Int {
        return user.imageURLs.count
    }
    
    var imageUrls: [URL?] {
        return user.imageURLs.map( { URL(string: $0) })
    }
    
    init(user: User) {
        self.user = user
    }
}
