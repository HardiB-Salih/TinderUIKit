//
//  ProfileCell.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/22/24.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    //MARK: - Properties
    let imageView = UIImageView()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "jane1")
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Helpers
    func configureUI() {
    }
}
