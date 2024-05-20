//
//  String + Extention.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

extension String {
    /// Creates a mutable attributed string with specified font and text color.
    /// - Parameters:
    ///   - font: The font to apply to the string.
    ///   - textColor: The color to apply to the string.
    /// - Returns: A mutable attributed string with the specified attributes.
    func mutableAttributedString(font: UIFont, textColor: UIColor = .white) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    /// Creates an immutable attributed string with specified font and text color.
    /// - Parameters:
    ///   - font: The font to apply to the string.
    ///   - textColor: The color to apply to the string.
    /// - Returns: An immutable attributed string with the specified attributes.
    func attributedString(font: UIFont, textColor: UIColor = .white) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.font: font, .foregroundColor: textColor])
    }
}



