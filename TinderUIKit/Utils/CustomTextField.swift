//
//  CustomTextField.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

class CustomTextField: UITextField {
    
    private let spacer = UIView()
    
    init(placeholder: String,
         isSecureTextEntry: Bool = false,
         keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.borderStyle = .none
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        self.textColor = .white
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.layer.cornerRadius = 5
        self.layer.cornerCurve = .continuous
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray6.withAlphaComponent(0.4).cgColor
        attributedPlaceholder = placeholder.attributedString(font: .systemFont(ofSize: 16), textColor: UIColor(white: 1, alpha: 0.7))
        
        // Adding left padding
        spacer.setDimensions(height: 44, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        // Adding right padding
        rightView = spacer
        rightViewMode = .always
        
        // Preventing autocomplete password suggestions
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
