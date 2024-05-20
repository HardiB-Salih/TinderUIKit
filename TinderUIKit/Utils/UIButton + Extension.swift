//
//  UIButton + Extension.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

extension UIButton {
    func configureButton(title: String? = nil,
                         attributedTitle: NSAttributedString? = nil,
                         font: UIFont = .systemFont(ofSize: 16, weight: .bold),
                         textColor: UIColor = .white,
                         cornerRadius: CGFloat = 5,
                         target: Any?,
                         action: Selector?,
                         for controlEvents: UIControl.Event = .touchUpInside
    ) {
        if let title = title {
            self.setTitle(title, for: .normal)
            self.setAttributedTitle(nil, for: .normal)
        } else if let attributedTitle = attributedTitle {
            self.setAttributedTitle(attributedTitle, for: .normal)
            self.setTitle(nil, for: .normal)
        }
        
        self.titleLabel?.font = font
        self.setTitleColor(textColor, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.layer.cornerRadius = cornerRadius
        self.layer.cornerCurve = .continuous
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.systemGray6.withAlphaComponent(0.6).cgColor
        
        if let target = target, let action = action {
            addTarget(target, action: action, for: controlEvents)
        }
    }
}
