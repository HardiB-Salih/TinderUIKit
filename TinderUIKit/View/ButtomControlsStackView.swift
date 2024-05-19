//
//  ButtomControlsStackView.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

class ButtomControlsStackView: UIStackView {
    
    // MARK: - Properties
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let supperLikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    // MARK: - Life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // Set images for the buttons
        let refreshImage = #imageLiteral(resourceName: "refresh_circle")
        let dislikeImage = #imageLiteral(resourceName: "dismiss_circle")
        let supperLikeImage = #imageLiteral(resourceName: "super_like_circle")
        let likeImage = #imageLiteral(resourceName: "like_circle")
        let boostImage = #imageLiteral(resourceName: "boost_circle")
        
        refreshButton.setImage(refreshImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(dislikeImage.withRenderingMode(.alwaysOriginal), for: .normal)
        supperLikeButton.setImage(supperLikeImage.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(likeImage.withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(boostImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // Add buttons to the stack view
        [refreshButton, dislikeButton, supperLikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

