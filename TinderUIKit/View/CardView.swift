//
//  CardView.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

class CardView: UIView {
    
    //MARK:  Properties
    private let gradientLayer = CAGradientLayer()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "lady4c.jpg")
        return imageView
    }()
    
    private let infoLable : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 2
        let attributedText = NSMutableAttributedString(string: "Jane Doe", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "  20", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        lable.attributedText = attributedText
        return lable
    }()
    
    
    private lazy var infoButton : UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "info_icon.png")
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // add thing that need meatherment like this
        gradientLayer.frame = self.frame
    }
    
    //MARK: - Public
    func setUpUI() {
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        configureGestureRecognizer()

        // We have to add views in Order
        backgroundColor = .systemRed
        addSubview(imageView)
        imageView.fillSuperview()

        configureGradientLayer()
        
        addSubview(infoLable)
        infoLable.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingLeft: 16, paddingBottom: 16, paddingRight: 16 + 40 )
 
        // How to set a dimention for a button
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.bottom(toView: infoLable)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
    }
    
    /// Configures a gradient layer for the view.
    func configureGradientLayer() {
        // Sets the colors for the gradient layer
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        // Sets the locations for the gradient colors
        gradientLayer.locations = [0.5, 1.1]
        
        // Adds the gradient layer as a sublayer of the view's layer
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
    
    
    //MARK: -OBJC
    /// Handles the pan gesture recognizer for the card.
    /// - Parameter sender: The UIPanGestureRecognizer object.
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        // Switches over the state of the gesture recognizer
        switch sender.state {
        case .began:
            // Removes all animations from subviews when the pan gesture begins
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            // Calls the method to change the position of the card
            changedCardPosition(sender)
        case .ended:
            // Calls the method to reset the position of the card
            resetCardPosition(sender)
        default:
            break
        }
    }


    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        print("Debug: Did Tap on photo")

    }
    //MARK: - Private
    /// Handles the pan gesture recognizer to change the position of the card.
    /// - Parameter sender: The UIPanGestureRecognizer object.
    private func changedCardPosition(_ sender: UIPanGestureRecognizer) {
        // Gets the translation of the gesture in the coordinate system of the specified view
        let translation = sender.translation(in: nil)
        
        // Calculates the rotation angle based on the horizontal translation
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        // Creates a rotational transform based on the calculated angle
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        
        // Combines the rotational transform with a translation transform
        // to achieve both rotation and translation effect
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }

    
    /// Resets the position of the card after the pan gesture ends.
    /// - Parameter sender: The UIPanGestureRecognizer object.
    private func resetCardPosition(_ sender: UIPanGestureRecognizer) {
        // Gets the translation of the gesture in the coordinate system of the specified view
        let translation = sender.translation(in: nil)
        
        // Determines the direction of the swipe based on the horizontal translation
        let direction: SwipeDirection = translation.x > 100 ? .right : .left
        
        // Checks if the card should be dismissed based on the horizontal translation
        let shouldDismissCard = abs(translation.x) > 100
        
        // Animates the card to its reset position
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1) {
            if shouldDismissCard {
                // If the card should be dismissed, translates it off-screen horizontally
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                // If the card should not be dismissed, resets its transform to identity (original position)
                self.transform = .identity
            }
        } completion: { _ in
            // Removes the card from its superview if it was dismissed
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }

    
}
