//
//  MatchCell.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//

import UIKit
import SDWebImage

class MatchCell: UICollectionViewCell {
    //MARK: - Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(height: 80, width: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.layer.cornerCurve = .continuous
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        return iv
    }()
    
    private let userNameLable: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(of: .footnote, weight: .semibold)
        lable.textColor = .darkGray
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, userNameLable])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 0
        
        addSubview(stack)
        stack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Helpers
    func configureCell(forMatch match: Match) {
        profileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        userNameLable.text = match.fullname.capitalized
    }
}
