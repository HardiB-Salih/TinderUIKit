//
//  HomeNavigationStackView.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    weak var delegate: HomeNavigationStackViewDelegate?
    /// #imageLiteral(resourceName: "exampleImage")
    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image:  #imageLiteral(resourceName: "app_icon") )
    
    
    //MARK: - Life sycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        
        let settingImage = #imageLiteral(resourceName: "top_left_profile")
        let messageImage = #imageLiteral(resourceName: "top_right_messages")

        settingButton.setImage(settingImage.withRenderingMode(.alwaysOriginal) , for: .normal)
        settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        messageButton.setImage(messageImage.withRenderingMode(.alwaysOriginal) , for: .normal)
        messageButton.addTarget(self, action: #selector(messageButtonClicked), for: .touchUpInside)

        [settingButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
//        isLayoutMarginsRelativeArrangement = true
//        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func messageButtonClicked(){
        delegate?.showMessages()
    }
    
    @objc func settingButtonClicked() {
        delegate?.showSettings()
    }
}
