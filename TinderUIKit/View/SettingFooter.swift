//
//  SettingFooter.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/22/24.
//

import UIKit
protocol SettingFooterDelegate: AnyObject {
    func handleLogout()
}

class SettingFooter : UIView {
    //MARK: - Properties
    weak var delegate: SettingFooterDelegate?
    
    lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        return button
    }()
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let spacer = UIView()
        spacer.backgroundColor = .systemGroupedBackground
        
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)
        
        addSubview(logOutButton)
        logOutButton.anchor(top: spacer.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Actions
    @objc func logoutClicked () {
        delegate?.handleLogout()
    }
}
