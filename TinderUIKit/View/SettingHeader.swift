//
//  SettingHeader.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/21/24.
//

import UIKit
import SDWebImage
import Kingfisher

protocol SettingHeaderDelegate : AnyObject {
    func settingHeader(_ header: SettingHeader, didSelect index: Int)
}

class SettingHeader: UIView {
    //MARK: - Properties
    private let user: User
    var buttons = [UIButton]()
    weak var delegate : SettingHeaderDelegate?


    //MARK: - Life cycle
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        
        
        let button1 = createButton(0)
        let button2 = createButton(1)
        let button3 = createButton(2)
        
        buttons = [button1, button2, button3]

        addSubview(button1)
        button1.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,
                       paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2, button3])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        addSubview(stack)
        stack.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor, right: rightAnchor,
                       paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        loadUserPhotos()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers

    func loadUserPhotos() {
        let imageURLs = user.imageURLs.map({ URL(string: $0)})
        for (index, url) in imageURLs.enumerated() {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self ] image , _, _, _, _, _ in
                self?.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    

    
    func createButton(_ tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = tag
        return button
    }
    
    @objc func handleSelectPhoto(_ sender: UIButton) {
        delegate?.settingHeader(self, didSelect: sender.tag)
        
    }
}
