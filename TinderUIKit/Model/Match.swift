//
//  Match.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//

import Foundation

struct Match {
    let fullname: String
    let profileImageUrl: String
    let uid: String
    
    
    init(dict: [String: Any]) {
        self.fullname = dict[.fullname] as? String ?? ""
        self.profileImageUrl = dict[.profileImageUrl] as? String ?? ""
        self.uid = dict[.uid] as? String ?? ""

    }
}

extension String {
    static let profileImageUrl  = "profileImageUrl"

}
