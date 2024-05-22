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
    func mutableAttributedString(font: UIFont  = .systemFont(of: .body, weight: .regular) , textColor: UIColor = .white) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    /// Creates an immutable attributed string with specified font and text color.
    /// - Parameters:
    ///   - font: The font to apply to the string.
    ///   - textColor: The color to apply to the string.
    /// - Returns: An immutable attributed string with the specified attributes.
    func attributedString(font: UIFont = .systemFont(of: .body, weight: .regular), textColor: UIColor = .white) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.font: font, .foregroundColor: textColor])
    }
}



//MARK: Apple Style Font
enum AppleSystemFont {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case subheadline
    case body
    case callout
    case footnote
    case caption1
    case caption2
    case custom(font: UIFont)
    
    var font: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title1:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .caption1:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        case .custom(let font):
            return font
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        case .title1:
            return UIFont.preferredFont(forTextStyle: .title1).pointSize
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2).pointSize
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3).pointSize
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline).pointSize
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline).pointSize
        case .body:
            return UIFont.preferredFont(forTextStyle: .body).pointSize
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout).pointSize
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote).pointSize
        case .caption1:
            return UIFont.preferredFont(forTextStyle: .caption1).pointSize
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2).pointSize
        case .custom(let font):
            return font.pointSize
        }
    }
}


// Extension to make the font bold
extension UIFont {
    static func systemFont(of styleSize: AppleSystemFont , weight: UIFont.Weight = .regular) -> UIFont {
        switch styleSize {
        case .largeTitle:
            return .systemFont(ofSize: AppleSystemFont.largeTitle.fontSize, weight: weight)
        case .title1:
            return .systemFont(ofSize: AppleSystemFont.title1.fontSize, weight: weight)
        case .title2:
            return .systemFont(ofSize: AppleSystemFont.title2.fontSize, weight: weight)
        case .title3:
            return .systemFont(ofSize: AppleSystemFont.title3.fontSize, weight: weight)
        case .headline:
            return .systemFont(ofSize: AppleSystemFont.headline.fontSize, weight: weight)
        case .subheadline:
            return .systemFont(ofSize: AppleSystemFont.subheadline.fontSize, weight: weight)
        case .body:
            return .systemFont(ofSize: AppleSystemFont.body.fontSize, weight: weight)
        case .callout:
            return .systemFont(ofSize: AppleSystemFont.callout.fontSize, weight: weight)
        case .footnote:
            return .systemFont(ofSize: AppleSystemFont.footnote.fontSize, weight: weight)
        case .caption1:
            return .systemFont(ofSize: AppleSystemFont.caption1.fontSize, weight: weight)
        case .caption2:
            return .systemFont(ofSize: AppleSystemFont.caption2.fontSize, weight: weight)
        case .custom(font: let font):
            return .systemFont(ofSize: font.pointSize, weight: weight)
        }
    }
    
    func italic() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitItalic) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: self.pointSize)
    }
}


