//
//  Extensions.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIColor {
    static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
}

extension UIViewController {
    func configureGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
}

extension UIView {
    
    //MARK: - Anchors
    /// Anchors a view to its superview or another view with optional padding and size constraints.
    /// - Parameters:
    ///   - top: The top anchor to which the view should be anchored.
    ///   - left: The left anchor to which the view should be anchored.
    ///   - bottom: The bottom anchor to which the view should be anchored.
    ///   - right: The right anchor to which the view should be anchored.
    ///   - paddingTop: The padding from the top anchor.
    ///   - paddingLeft: The padding from the left anchor.
    ///   - paddingBottom: The padding from the bottom anchor.
    ///   - paddingRight: The padding from the right anchor.
    ///   - width: The width of the view. If nil, no width constraint is applied.
    ///   - height: The height of the view. If nil, no height constraint is applied.
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    /// Centers the view horizontally within another view.
    /// - Parameter view: The view within which the current view should be horizontally centered.
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// Centers the view vertically within another view with optional left anchor, padding, and constant.
    /// - Parameters:
    ///   - view: The view within which the current view should be vertically centered.
    ///   - leftAnchor: The left anchor to which the view should be aligned. If nil, the view will be centered horizontally.
    ///   - paddingLeft: The padding from the left anchor.
    ///   - constant: The constant offset for the vertical centering.
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    /// Sets the dimensions of the view with the specified height and width.
    /// - Parameters:
    ///   - height: The height of the view.
    ///   - width: The width of the view.
    func setDimensions(height: CGFloat, width: CGFloat) {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Creates a constraint to set the height of the view
        heightAnchor.constraint(equalToConstant: height).isActive = true
        // Creates a constraint to set the width of the view
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /// Anchors the view to specified layout anchors with optional padding and size constraints.
    /// - Parameters:
    ///   - top: The top anchor to which the view should be anchored.
    ///   - leading: The leading (left) anchor to which the view should be anchored.
    ///   - bottom: The bottom anchor to which the view should be anchored.
    ///   - trailing: The trailing (right) anchor to which the view should be anchored.
    ///   - padding: The padding around the view from its anchors.
    ///   - size: The size of the view.
    /// - Returns: An instance of `AnchoredConstraints` containing the constraints applied.
    @discardableResult
    public func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Initializes an instance of AnchoredConstraints to hold the constraints
        var anchoredConstraints = AnchoredConstraints()
        
        // Creates constraints for top anchor
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        // Creates constraints for leading anchor
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        // Creates constraints for bottom anchor
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        // Creates constraints for trailing anchor
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        // Creates constraint for width if specified
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        // Creates constraint for height if specified
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        // Activates all constraints
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        // Returns the AnchoredConstraints instance
        return anchoredConstraints
    }

    
    /// Fills the superview with the current view, applying optional padding.
    /// - Parameter padding: The padding around the view from its superview.
    /// - Returns: An instance of `AnchoredConstraints` containing the constraints applied.
    @discardableResult
    public func fillSuperview(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Initializes an instance of AnchoredConstraints to hold the constraints
        let anchoredConstraints = AnchoredConstraints()
        
        // Checks if the superview's anchors are available
        guard let superviewTopAnchor = superview?.topAnchor,
              let superviewBottomAnchor = superview?.bottomAnchor,
              let superviewLeadingAnchor = superview?.leadingAnchor,
              let superviewTrailingAnchor = superview?.trailingAnchor else {
            return anchoredConstraints
        }
        
        // Anchors the view to its superview with the specified padding
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
    }

    
    /// Fills the safe area layout guide of the superview with the current view, applying optional padding.
    /// - Parameter padding: The padding around the view from its superview's safe area layout guide.
    /// - Returns: An instance of `AnchoredConstraints` containing the constraints applied.
    @discardableResult
    public func fillSuperviewSafeAreaLayoutGuide(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        // Initializes an instance of AnchoredConstraints to hold the constraints
        let anchoredConstraints = AnchoredConstraints()
        
        // Checks if iOS version supports safe area layout guide
        if #available(iOS 11.0, *) {
            // Checks if the superview's safe area layout guide anchors are available
            guard let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
                  let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
                  let superviewLeadingAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
                  let superviewTrailingAnchor = superview?.safeAreaLayoutGuide.trailingAnchor else {
                return anchoredConstraints
            }
            // Anchors the view to the superview's safe area layout guide with the specified padding
            return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
            
        } else {
            return anchoredConstraints
        }
    }

    
    /// Centers the view in its superview with optional size.
    /// - Parameter size: The size of the view.
    public func centerInSuperview(size: CGSize = .zero) {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        
        // Centers the view horizontally in its superview
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        // Centers the view vertically in its superview
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        // Sets the width of the view if specified
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        // Sets the height of the view if specified
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    
    /// Centers the view horizontally in its superview.
    public func centerXToSuperview() {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        
        // Centers the view horizontally in its superview
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
    }

    
    /// Centers the view vertically in its superview.
    public func centerYToSuperview() {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        
        // Centers the view vertically in its superview
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }

    
    /// Constrains the height of the view to a specific constant value.
    /// - Parameter constant: The constant value for the height constraint.
    /// - Returns: An instance of `AnchoredConstraints` containing the height constraint applied.
    @discardableResult
    public func constrainHeight(_ constant: CGFloat) -> AnchoredConstraints {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        
        // Initializes an instance of AnchoredConstraints to hold the constraints
        var anchoredConstraints = AnchoredConstraints()
        
        // Creates a constraint for the height of the view with the specified constant
        anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
        
        // Activates the height constraint
        anchoredConstraints.height?.isActive = true
        
        // Returns the AnchoredConstraints instance
        return anchoredConstraints
    }

    
    /// Constrains the width of the view to a specific constant value.
    /// - Parameter constant: The constant value for the width constraint.
    /// - Returns: An instance of `AnchoredConstraints` containing the width constraint applied.
    @discardableResult
    public func constrainWidth(_ constant: CGFloat) -> AnchoredConstraints {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        
        // Initializes an instance of AnchoredConstraints to hold the constraints
        var anchoredConstraints = AnchoredConstraints()
        
        // Creates a constraint for the width of the view with the specified constant
        anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
        
        // Activates the width constraint
        anchoredConstraints.width?.isActive = true
        
        // Returns the AnchoredConstraints instance
        return anchoredConstraints
    }

    
    /// Sets up a shadow for the view with specified properties.
    /// - Parameters:
    ///   - opacity: The opacity of the shadow.
    ///   - radius: The radius of the shadow.
    ///   - offset: The offset of the shadow.
    ///   - color: The color of the shadow.
    public func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        // Sets the opacity of the shadow
        layer.shadowOpacity = opacity
        // Sets the radius of the shadow
        layer.shadowRadius = radius
        // Sets the offset of the shadow
        layer.shadowOffset = offset
        // Sets the color of the shadow
        layer.shadowColor = color.cgColor
    }

    
    /// Initializes a view with the specified background color.
    /// - Parameter backgroundColor: The background color of the view.
    convenience public init(backgroundColor: UIColor = .clear) {
        // Initializes the view with zero frame
        self.init(frame: .zero)
        // Sets the background color of the view
        self.backgroundColor = backgroundColor
    }

}


extension UIView {
    /// Anchors the top of the view to another view with optional constraints.
    /// - Parameters:
    ///   - view: The view to which the top of the current view should be anchored.
    ///   - constant: The constant offset for the top anchor.
    ///   - leftAnchor: The left anchor to which the view should be aligned.
    ///   - paddingLeft: The padding from the left anchor.
    ///   - bottomAnchor: The bottom anchor to which the view should be aligned.
    ///   - paddingBottom: The padding from the bottom anchor.
    ///   - rightAnchor: The right anchor to which the view should be aligned.
    ///   - paddingRight: The padding from the right anchor.
    ///   - width: The width of the view.
    ///   - height: The height of the view.
    func top(toView view: UIView, constant: CGFloat = 0,
             leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0,
             bottomAnchor: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0,
             rightAnchor: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat = 0,
             width: CGFloat? = nil, height: CGFloat? = nil) {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Anchors the top of the view to the top of the specified view with the constant offset
        topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        
        // Aligns the left anchor of the view with the specified anchor with padding if provided
        if let left = leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        // Aligns the bottom anchor of the view with the specified anchor with padding if provided
        if let bottom = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        // Aligns the right anchor of the view with the specified anchor with padding if provided
        if let right = rightAnchor {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        // Sets the width of the view if specified
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        // Sets the height of the view if specified
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    
    
    /// Anchors the bottom of the view to another view with optional constraints.
    /// - Parameters:
    ///   - view: The view to which the bottom of the current view should be anchored.
    ///   - constant: The constant offset for the bottom anchor.
    ///   - leftAnchor: The left anchor to which the view should be aligned.
    ///   - paddingLeft: The padding from the left anchor.
    ///   - topAnchor: The top anchor to which the view should be aligned.
    ///   - paddingTop: The padding from the top anchor.
    ///   - rightAnchor: The right anchor to which the view should be aligned.
    ///   - paddingRight: The padding from the right anchor.
    ///   - width: The width of the view.
    ///   - height: The height of the view.
    func bottom(toView view: UIView, constant: CGFloat = 0,
                leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0,
                topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0,
                rightAnchor: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat = 0,
                width: CGFloat? = nil, height: CGFloat? = nil) {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Anchors the bottom of the view to the bottom of the specified view with the constant offset
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
        
        // Aligns the left anchor of the view with the specified anchor with padding if provided
        if let left = leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        // Aligns the top anchor of the view with the specified anchor with padding if provided
        if let top = topAnchor {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        // Aligns the right anchor of the view with the specified anchor with padding if provided
        if let right = rightAnchor {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        // Sets the width of the view if specified
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        // Sets the height of the view if specified
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    
    /// Anchors the left side of the view to another view with optional constraints.
    /// - Parameters:
    ///   - view: The view to which the left side of the current view should be anchored.
    ///   - constant: The constant offset for the left anchor.
    ///   - topAnchor: The top anchor to which the view should be aligned.
    ///   - paddingTop: The padding from the top anchor.
    ///   - bottomAnchor: The bottom anchor to which the view should be aligned.
    ///   - paddingBottom: The padding from the bottom anchor.
    ///   - rightAnchor: The right anchor to which the view should be aligned.
    ///   - paddingRight: The padding from the right anchor.
    ///   - width: The width of the view.
    ///   - height: The height of the view.
    func left(toView view: UIView, constant: CGFloat = 0,
              topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0,
              bottomAnchor: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0,
              rightAnchor: NSLayoutXAxisAnchor? = nil, paddingRight: CGFloat = 0,
              width: CGFloat? = nil, height: CGFloat? = nil) {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Anchors the left side of the view to the left side of the specified view with the constant offset
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant).isActive = true
        
        // Aligns the top anchor of the view with the specified anchor with padding if provided
        if let top = topAnchor {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        // Aligns the bottom anchor of the view with the specified anchor with padding if provided
        if let bottom = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        // Aligns the right anchor of the view with the specified anchor with padding if provided
        if let right = rightAnchor {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        // Sets the width of the view if specified
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        // Sets the height of the view if specified
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    
    /// Anchors the right side of the view to another view with optional constraints.
    /// - Parameters:
    ///   - view: The view to which the right side of the current view should be anchored.
    ///   - constant: The constant offset for the right anchor.
    ///   - topAnchor: The top anchor to which the view should be aligned.
    ///   - paddingTop: The padding from the top anchor.
    ///   - bottomAnchor: The bottom anchor to which the view should be aligned.
    ///   - paddingBottom: The padding from the bottom anchor.
    ///   - leftAnchor: The left anchor to which the view should be aligned.
    ///   - paddingLeft: The padding from the left anchor.
    ///   - width: The width of the view.
    ///   - height: The height of the view.
    func right(toView view: UIView, constant: CGFloat = 0,
               topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0,
               bottomAnchor: NSLayoutYAxisAnchor? = nil, paddingBottom: CGFloat = 0,
               leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0,
               width: CGFloat? = nil, height: CGFloat? = nil) {
        // Ensures autoresizing masks are not translated into constraints
        translatesAutoresizingMaskIntoConstraints = false
        // Anchors the right side of the view to the right side of the specified view with the constant offset
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -constant).isActive = true
        
        // Aligns the top anchor of the view with the specified anchor with padding if provided
        if let top = topAnchor {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        // Aligns the bottom anchor of the view with the specified anchor with padding if provided
        if let bottom = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        // Aligns the left anchor of the view with the specified anchor with padding if provided
        if let left = leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        // Sets the width of the view if specified
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        // Sets the height of the view if specified
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
