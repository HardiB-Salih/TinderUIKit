//
//  UIButton + Extention.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//


import UIKit

enum GradientDirection {
    case top
    case topLeading
    case topTrailing
    case bottom
    case bottomLeading
    case bottomTrailing
    case left
    case right
    case custom(startPoint: CGPoint, endPoint: CGPoint)
    
    var point: CGPoint {
        switch self {
        case .top:
            return CGPoint(x: 0.5, y: 0.0)
        case .topLeading:
            return CGPoint(x: 0.0, y: 0.0)
        case .topTrailing:
            return CGPoint(x: 1.0, y: 0.0)
        case .bottom:
            return CGPoint(x: 0.5, y: 1.0)
        case .bottomLeading:
            return CGPoint(x: 0.0, y: 1.0)
        case .bottomTrailing:
            return CGPoint(x: 1.0, y: 1.0)
        case .left:
            return CGPoint(x: 0.0, y: 0.5)
        case .right:
            return CGPoint(x: 1.0, y: 0.5)
        case .custom(let startPoint, _):
            return startPoint
        }
    }
    
    static func points(start: GradientDirection, end: GradientDirection) -> (start: CGPoint, end: CGPoint) {
        return (start.point, end.point)
    }
}


class BorderGradientButton: UIButton {
    
    private var gradientLayer: CAGradientLayer?
    private var borderWidth: CGFloat = 0
    private var cornerRadius: CGFloat = 0
    private var innerCornerRadius: CGFloat = 0

    func applyBorderGradient(colors: [UIColor], startPoint: GradientDirection, endPoint: GradientDirection, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.innerCornerRadius = cornerRadius - (1.5 * borderWidth)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        
        let points = GradientDirection.points(start: startPoint, end: endPoint)
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
        
        let maskLayer = CAShapeLayer()
        let maskPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        maskPath.append(UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: innerCornerRadius))
        maskLayer.path = maskPath.cgPath
        maskLayer.fillRule = .evenOdd
        gradientLayer.mask = maskLayer
        
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
        
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the gradient layer frame and mask when the button's layout changes
        gradientLayer?.frame = bounds
        if let maskLayer = gradientLayer?.mask as? CAShapeLayer {
            let maskPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            maskPath.append(UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: innerCornerRadius))
            maskLayer.path = maskPath.cgPath
        }
    }
}




class BackgroundGradientButton: UIButton {
    
    func applyBackgroundGradient(colors: [UIColor], startPoint: GradientDirection, endPoint: GradientDirection, cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        
        let points = GradientDirection.points(start: startPoint, end: endPoint)
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
        
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        
        // Remove any existing background gradient layers
        layer.sublayers?.filter { $0 is CAGradientLayer && $0.name == "backgroundGradientLayer" }.forEach { $0.removeFromSuperlayer() }
        
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.name = "backgroundGradientLayer"
        
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the gradient layer frame when the button's layout changes
        if let gradientLayer = layer.sublayers?.first(where: { $0.name == "backgroundGradientLayer" }) as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
}
