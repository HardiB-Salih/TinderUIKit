//
//  CardView.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: AnyObject {
    func cardView(_ View: CardView, wantToShowProfileFor user: User)
}

class CardView: UIView {
    
    private var cardViewModel: CardViewModel
    
    //MARK:  Properties
    weak var delegate: CardViewDelegate?
    private let gradientLayer = CAGradientLayer()
    private lazy var barStackView = SegmentedBarView(numberOfSegments: cardViewModel.imageURLs.count)
    
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var infoLable : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 2
        lable.attributedText = cardViewModel.user.attributedNameWithAge()
        return lable
    }()
    
    
    private lazy var infoButton : UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "info_icon.png")
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    init(viewModel: CardViewModel) {
        self.cardViewModel = viewModel
        super.init(frame: .zero)
        imageView.sd_setImage(with: URL(string: viewModel.imageToShow))
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
        backgroundColor = .white
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
        infoButton.addTarget(self, action: #selector(infoButtonClicked), for: .touchUpInside)
        
        if cardViewModel.imageURLs.count > 1 {
            configureBarStackView()
        }
       
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
    @objc func infoButtonClicked() {
        delegate?.cardView(self, wantToShowProfileFor: cardViewModel.user)
    }
    
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


    
    /// Handles the tap gesture to change the displayed photo.
    ///
    /// - Parameter sender: The UITapGestureRecognizer object.
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            cardViewModel.showNextPhoto()
        } else {
            cardViewModel.showPreviousPhoto()
        }

        imageView.crossDissolveTransition(toImageURL: cardViewModel.imageToShow, duration: 0.7)
        if cardViewModel.imageURLs.count > 1 {
            barStackView.setHighlighted(index: cardViewModel.index)
        }
    }
    
    func configureBarStackView() {
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 8, paddingLeft: 30 ,paddingRight: 30 ,
                            height: 4 )
        
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
        
        bounceAnimation {
            if shouldDismissCard {
                // If the card should be dismissed, translates it off-screen horizontally
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                // If the card should not be dismissed, resets its transform to identity (original position)
                self.transform = .identity
            }
        } completion: {
            // Removes the card from its superview if it was dismissed
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }

    
}
